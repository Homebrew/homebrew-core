class Epr < Formula
  include Language::Python::Virtualenv

  desc "Command-line EPUB reader"
  homepage "https://github.com/wustho/epr"
  url "https://files.pythonhosted.org/packages/7e/1a/cfaa2e62daa81730e8a176d266264d863fff321fffc1bcc6ee91847ffee5/epr-reader-2.4.10.tar.gz"
  sha256 "23d5b7e04022097c49833497d298e1c7cb2152cd278ab96904fb697460e041bd"
  license "MIT"
  head "https://github.com/wustho/epr.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "51116f63d11e596b554f0016ea5f4b2c18b141e90cd85ffce8e41ac93df68be0"
    sha256 cellar: :any_skip_relocation, big_sur:       "be4776e7adf94d57e99d6bb002b8f089fc07c2c298cafb3640c202947e3919d3"
    sha256 cellar: :any_skip_relocation, catalina:      "83a37ff011aab1502db680eedb3ad68718a5e228edbf773de22a048a6101ed78"
    sha256 cellar: :any_skip_relocation, mojave:        "a74d3f565535bd6867a7d8c47f7f8093375313cb88749b36e900f386d2ee837f"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Reading history:", shell_output("#{bin}/epr -r")
  end
end
