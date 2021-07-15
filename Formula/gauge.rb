class Gauge < Formula
  desc "Test automation tool that supports executable documentation"
  homepage "https://gauge.org"
  url "https://github.com/getgauge/gauge/archive/v1.3.3.tar.gz"
  sha256 "c599f4c734dc125b38ff1559987fb8d6ce285c650b909b31a84e27399ea0c15c"
  license "Apache-2.0"
  head "https://github.com/getgauge/gauge.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ae89fe6cd6b11394020100411dfbb7cea4f53d90235cbc2ddaf26fe58b29753"
    sha256 cellar: :any_skip_relocation, big_sur:       "779c2e041fd7f5e0b7535bbb6ff6da4771c0808bb028f552fbc8e13fedf75a98"
    sha256 cellar: :any_skip_relocation, catalina:      "9bd288a71e471daa07164838780675b8e6669162bbb2b659ba2da7aa7c972a02"
    sha256 cellar: :any_skip_relocation, mojave:        "2daa3523bd3e92c0b6aa5ed0d4954329833f4424a3a96dbc907c2ce4475f9317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cc9e798767cba30256b7ac7f8201bb45d019f81dbb88ba60852acf83e9cb76a"
  end

  depends_on "go" => :build

  def install
    system "go", "run", "build/make.go"
    system "go", "run", "build/make.go", "--install", "--prefix", prefix
  end

  test do
    (testpath/"manifest.json").write <<~EOS
      {
        "Plugins": [
          "html-report"
        ]
      }
    EOS

    system("#{bin}/gauge", "install")
    assert_predicate testpath/".gauge/plugins", :exist?

    system("#{bin}/gauge", "config", "check_updates", "false")
    assert_match "false", shell_output("#{bin}/gauge config check_updates")

    assert_match version.to_s, shell_output("#{bin}/gauge -v 2>&1")
  end
end
