class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.23.1/detekt-cli-1.23.1-all.jar"
  sha256 "089c15405ec5563adba285d09ceccff047ebc7888b8bbc3a386bbc6c6744d788"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, sonoma:         "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, ventura:        "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, monterey:       "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eeea827ea295112b149ed51f0a954d25f29c4b06696be6517db3cac1175134a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d212935e52e998855e8093b00010af6fd223ac5be0b59c04f3e7420e77176259"
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
