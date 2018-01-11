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
    sha256 "fc0185c33c354229a85e33a122652d1e17b81a163da3689bb62e1cd0477ba328" => :high_sierra
    sha256 "fe55d19f3636ebd3a468f1a5da19ac94450f9802b0b2144d69db194a31f5b876" => :sierra
    sha256 "1f18fdcc215966f3d3e68efc7f724235d6901810002dae343114fc62ff499def" => :el_capitan
    sha256 "619756b72cb0680b449ff55011f53f6c90a155e7c4ca01a9c4c85d251c394fe6" => :yosemite
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
