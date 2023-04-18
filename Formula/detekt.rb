class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.22.0/detekt-cli-1.22.0-all.jar"
  sha256 "34238c05c02d93b70e94fdc7f01cff85f47fdf4e63fc37daa05af0739d386ffe"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0803c5a28780fc4fca5d86aeb440624d9a3477f8aceff76d70726528796d090c"
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
