class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.org/"
  url "https://files.pythonhosted.org/packages/28/93/4ebf2de4bc74bd517a27a600b2b23a5254a20f28e6e36fc876fd98f7a51b/httpie-0.9.9.tar.gz"
  sha256 "f1202e6fa60367e2265284a53f35bfa5917119592c2ab08277efc7fffd744fcb"
  revision 1
  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e9abd00651c18fce7eaf9b771342f32b476041a0745f951a318d0653bce18b" => :high_sierra
    sha256 "2172c38aab5947eb2f8fdb65778f0bd103e7393062bed15660b6eb3321dd881d" => :sierra
    sha256 "24747f7be600fba469ae613ee4ed322d209e77054a6b2d53168dde92eec246b9" => :el_capitan
  end

  depends_on "python3"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d9/03/155b3e67fe35fe5b6f4227a8d9e96a14fda828b18199800d161bcefc1359/requests-2.12.3.tar.gz"
    sha256 "de5d266953875e9647e37ef7bfe6ef1a46ff8ddfe61b5b3652edf7ea717ee2b2"
  end

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/fd/70/ba9982cedc9b3ed3c06934f1f46a609e0f23c7bfdf567c52a09f1296b8cb/PySocks-1.6.6.tar.gz"
    sha256 "02419a225ff5dcfc3c9695ef8fc9b4d8cc99658e650c6d4718d4c8f451e63f41"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end
