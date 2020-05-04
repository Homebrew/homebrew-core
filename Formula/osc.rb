class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.168.2.tar.gz"
  sha256 "070637e052ad18416cf27b49b53685f802addac8da9f9a36ac8069dcdb1757c4"
  revision 2
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "51a3724d6bd9c9db4c0b8f65c117dcd09b1db222d55d5573f23ff4e1ff8bffbb" => :catalina
    sha256 "9d8b4a4b842e986c32612e8f75e5e18a0d838ca6f333fb51e9b09529181533b6" => :mojave
    sha256 "6c32633cae045ea732ae31857da203cae2c791d96c1b6e5448aa3fb145b51a76" => :high_sierra
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
    ENV["SWIG_FEATURES"] = "-I#{Formula["openssl@1.1"].opt_include}"

    inreplace "osc/conf.py", "'/etc/ssl/certs'", "'#{etc}/openssl@1.1/cert.pem'"
    virtualenv_install_with_resources
    mv bin/"osc-wrapper.py", bin/"osc"
  end

  test do
    system bin/"osc", "--version"
  end
end
