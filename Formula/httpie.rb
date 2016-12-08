class Httpie < Formula
  include Language::Python::Virtualenv

  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.org/"
  url "https://github.com/jkbrzt/httpie/archive/0.9.8.tar.gz"
  sha256 "5ccc65dd8e60a9310f575c1a9600f3cc7daf8704cc88bf6c40118b3659b98dc7"
  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    sha256 "0334c408f0b52b5c41dd275f1e781b096826e802f5f37207eea73818b9ce685b" => :sierra
    sha256 "1d87eb3e00e47a8026a90ea635f38818d3284f387e51716fc28167a4f22b96b9" => :el_capitan
    sha256 "e4def5f34b154f206520df3dfbb26024616e22c3625da9dd5f2456f6ca38eccc" => :yosemite
  end

  depends_on :python3

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/d9/03/155b3e67fe35fe5b6f4227a8d9e96a14fda828b18199800d161bcefc1359/requests-2.12.3.tar.gz"
    sha256 "de5d266953875e9647e37ef7bfe6ef1a46ff8ddfe61b5b3652edf7ea717ee2b2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end
