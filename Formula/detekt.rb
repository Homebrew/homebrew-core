class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.20.0/detekt-cli-1.20.0-all.jar"
  sha256 "2e4f299cc50b010fa99f44893e0fca68ef1efb57f9e6c3758c7b021804d36c59"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d0afd41343f5e70d9fb2ecdc70c82d9380e963114167b8de6b207fa4cefac27"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "detekt-cli-#{version}-all.jar"
    bin.write_jar_script libexec/"detekt-cli-#{version}-all.jar", "detekt", java_version: "11"
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
