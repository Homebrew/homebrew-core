class Gimmecert < Formula
  include Language::Python::Virtualenv

  desc "Quickly issue X.509 server and client certificates using locally-generated CA"
  homepage "https://projects.majic.rs/gimmecert"
  url "https://files.pythonhosted.org/packages/94/b3/f8d0d4fc8951d7ff02f1d3653ba446ad0edf14ab1a18cff4fbe1d1b62086/gimmecert-1.0.0.tar.gz"
  sha256 "eb00848fab5295903b4d5ef997c411fe063abc5b0f520a78ca2cd23f77e3fd99"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "975ac251c006b05622cd2d37e62308fe7ee4b5d6122f5867d07f851f1feba17b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c5201da0004e7f9585bd5cb41aab648ab5f1039f1dd207685aed98812cdab14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1752190b88dd16f222c29ffeefb8e4273ce41272df77f653140ece125909e897"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35c4e73239bff368cf4f6aaa72a0b4b90c76e48039b74a3d89c1199ff1cfdda5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e3eea83a6e11530a8c4f98d9892ba49d7768b8c965d0adde074cf24b1e0d5afb"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d86da82e02647ab2a58b743eca70f1173f571966bb2524a35fa41d3dc456b3"
    sha256 cellar: :any_skip_relocation, monterey:       "52adedab6ad1d8eb70ef10fa042a94a25a77a45b5e5169eb02df755c0f4ffc97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fb4c2af0f720f970c8aab3281801a3125547e484de41552d49330706dee53dd"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.12"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output1 = shell_output(bin/"gimmecert init")
    assert_match "CA hierarchy initialised using 2048-bit RSA keys", output1

    output2 = shell_output(bin/"gimmecert status")
    assert_match "No server certificates have been issued", output2

    assert_predicate testpath/".gimmecert/ca/level1.key.pem", :exist?
    assert_predicate testpath/".gimmecert/ca/level1.cert.pem", :exist?
    assert_predicate testpath/".gimmecert/ca/chain-full.cert.pem", :exist?
  end
end
