class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.174.0.tar.gz"
  sha256 "9be35b347fa07ac1235aa364b0e1229c00d5e98e202923d7a8a796e3ca2756ad"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "45441960ddc65f31038defce4cf7f0076f0b1fec4f60f68ce7a65d5e88ad7693"
    sha256 cellar: :any,                 big_sur:       "3c84a1c831e92feb2b15bdac1fec6eb42b1bfffabab32fc2d4094dfac49d37ac"
    sha256 cellar: :any,                 catalina:      "3da92871b821363036565c492d208e24fa3fe1132f14c24c00f1b41994d88abe"
    sha256 cellar: :any,                 mojave:        "20244925520f2da62da2f484bbf154abbe89d1bb51764635b7324a614b3e6ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfbea02d2d0e71810c128370c530ca7a6bfc7a8079808c511782ad52d45a2b2c"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/2c/52/c35ec79dd97a8ecf6b2bbd651df528abb47705def774a4a15b99977274e8/M2Crypto-0.38.0.tar.gz"
    sha256 "99f2260a30901c949a8dc6d5f82cd5312ffb8abc92e76633baf231bbbcb2decb"
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
