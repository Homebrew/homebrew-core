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
    sha256 "ce00021e980c530d2b3fccb16698f2869462bb59fd7b054b92a95024565ec840" => :big_sur
    sha256 "92515d809578b1cf136cc46dfdbde614179c68fdb58b12b619cbd5a6c3dd956a" => :arm64_big_sur
    sha256 "bf7953f981826e73bd4be7ef9b1e8d4127afebd95febe9659a1b0f10a389e9a6" => :catalina
    sha256 "6b55d18a07e128e2811a8c3c8d8bceed67201a4761977903b68780e8fc405225" => :mojave
    sha256 "b5438d36082a8d13b22de3c7a4f67399ff8899707658e9146af73e8c572bda6c" => :high_sierra
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
