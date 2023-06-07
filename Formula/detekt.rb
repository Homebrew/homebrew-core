class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/detekt/detekt"
  url "https://github.com/detekt/detekt/releases/download/v1.23.0/detekt-cli-1.23.0-all.jar"
  sha256 "5e699cc9fc1664013d3d06ba4cfd8766c9fb8800f031405dc4c69df236161fda"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, ventura:        "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, monterey:       "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "42c506a148d0cf161d78f79b7389f85319e90b83b6900cc7cbeaea621b78e8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb9d906989f2b1b7cb8d874ec9aff4e11e627a9b72b58f11ee8b07f3e34134b"
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
