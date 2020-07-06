class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.169.1.tar.gz"
  sha256 "ae87225d4ce3ca115a95188235ecd90b008b0e6b25b79ba818c5e7d09e7ec7d6"
  license "GPL-2.0"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "c0b5be694e7a7be280746d507ab928392365d24c4f5130f5070e9da6169f744a" => :catalina
    sha256 "452a9846612deb1fa4205b492152826ea3d11e0391dab3f6633f8fd04395313a" => :mojave
    sha256 "ac1bb79ace0cc7eb7e5abe8bbb36cf67bbaaed1ce4b5d3d2dcbd360672308b44" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/74/18/3beedd4ac48b52d1a4d12f2a8c5cf0ae342ce974859fba838cbbc1580249/M2Crypto-0.35.2.tar.gz"
    sha256 "4c6ad45ffb88670c590233683074f2440d96aaccb05b831371869fc387cbd127"
  end

  def install
    openssl = Formula["openssl@1.1"]
    ENV["SWIG_FEATURES"] = "-I#{openssl.opt_include}"

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{openssl.pkgetc}/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
