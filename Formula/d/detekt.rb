class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.23.6/detekt-cli-1.23.6-all.jar"
  sha256 "898dcf810e891f449e4e3f9f4a4e2dc75aecf8e1089df41a42a69adb2cbbcffa"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b3e9326188f8494eb7805e6b842543c80eb94c292bf8ab87294d0c578818945e"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    # remove `--add-opens` after https://github.com/detekt/detekt/issues/5576
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt", "--add-opens java.base/java.lang=ALL-UNNAMED", java_version: "17"
  end

  test do
    # generate default config for testing
    system bin/"detekt", "--generate-config"
    assert_match "empty-blocks:", File.read(testpath/"detekt.yml")

    (testpath/"input.kt").write <<~EOS
      fun main() {

      }
    EOS
    shell_output("#{bin}/detekt --input input.kt --report txt:output.txt --config #{testpath}/detekt.yml", 2)
    assert_equal "EmptyFunctionBlock", shell_output("cat output.txt").slice(/\w+/)
  end
end
