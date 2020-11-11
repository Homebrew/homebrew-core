class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.171.0.tar.gz"
  sha256 "e824480c1c5811b05ea18236cd13164a15f7bcf17df929b43ed0617cfcb60f80"
  license "GPL-2.0"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "b2aa3b4e18cc276e8cd7b106536928c264ed0c8285dee224a599005226a5dda9" => :catalina
    sha256 "f0471fc36c7500321c0d73bfab89a906d07a595bfb9153a2d36e11b243b88009" => :mojave
    sha256 "ba1d33560353790c715e5dd1234acd695c392a25a866cf0e303ae8ee892f4908" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/ff/df/84609ed874b5e6fcd3061a517bf4b6e4d0301f553baf9fa37bef2b509797/M2Crypto-0.36.0.tar.gz"
    sha256 "1542c18e3ee5c01db5031d0b594677536963e3f54ecdf5315aeecb3a595b4dc1"
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
