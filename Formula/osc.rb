class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.179.0.tar.gz"
  sha256 "543a9e1a4f2dc722a5228b41a8da92867a35fa52f9701dc213108fa9b35085e8"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "48a08e2f71218f22c3c2b371eda97028f3643f5f7c167a9ce178631b37b6b721"
    sha256 cellar: :any,                 arm64_big_sur:  "2ca6d86977a3661464e2dcc65eb4a6627f23ec4928f2df18eff23c0ca2ecf6e7"
    sha256 cellar: :any,                 monterey:       "da75a759dca5f84985b14a54213effb63d58e33a69d17b3c0daf1baca2df5274"
    sha256 cellar: :any,                 big_sur:        "6c3a82e64eb447bd1f722284b8470f660010d3e5788c2116fe81077455a21cea"
    sha256 cellar: :any,                 catalina:       "51da3cee464d621883f9c6b1d20c34d8fbdc7782c4775984f2fa2bd35ac720af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "848048abf5a705d9a86bd64cb4a9ecda9231030616dca31b7979c89fb578e386"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

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
