class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.21.0/detekt-cli-1.21.0-all.jar"
  sha256 "67e1bb5f2748d1bedadc3c3c06c75a04f8197d71f4d1d26724a49a42edbfa3c2"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3b227d1d82c944a21062fd3f2220ba157014a821d9c554ccec91681e95067d9"
  end

  depends_on "openjdk@17"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt", java_version: "17"
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
