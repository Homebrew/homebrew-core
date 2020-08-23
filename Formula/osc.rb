class Osc < Formula
  include Language::Python::Virtualenv

  desc "The command-line interface to work with an Open Build Service"
  homepage "https://github.com/openSUSE/osc"
  url "https://github.com/openSUSE/osc/archive/0.170.0.tar.gz"
  sha256 "137d199fd2dad149eda2263155a800459f8553a5162fd7aaa947175e399272df"
  license "GPL-2.0"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    cellar :any
    sha256 "6f7b7924a56578ae1a1b414da03835554903cd10737f5c4c21c932880254cfca" => :catalina
    sha256 "5cb73eaa794a8bc687a42d5d19c768d59e9fdfb28e44c05d30425cc4867555aa" => :mojave
    sha256 "7b413c1f238bd4f33df5a80e6b63de2005024e1e854fd07ff158d8a8644ec1f2" => :high_sierra
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
