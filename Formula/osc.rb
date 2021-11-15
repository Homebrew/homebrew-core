class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.174.0.tar.gz"
  sha256 "9be35b347fa07ac1235aa364b0e1229c00d5e98e202923d7a8a796e3ca2756ad"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "599f8515898fc6b2592434cfe8920bc6a05becbc1715c820b2cde12386bb5ba6"
    sha256 cellar: :any,                 arm64_big_sur:  "537ad65c12cb4a633f5f52dada6121947c90750983e289165ed8e2b1fc0ca3d9"
    sha256 cellar: :any,                 monterey:       "ffdaf4c3e9c80206c4bc722e7d4d9f28ca77dfe84d7d8d29d2624a56ffeba13a"
    sha256 cellar: :any,                 big_sur:        "da58b8627f227b386b87ac8b558fb79a1d7b90c1ed60674639187928ab00197a"
    sha256 cellar: :any,                 catalina:       "adb60d9fc75fe8696bde10876cd878ea8ce7b75a6b13401dc7d8c3f3dcbb77ef"
    sha256 cellar: :any,                 mojave:         "d2bc5039ffcecc4163a88a606790bfa743a77433c86613dfa23421db39aad095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2279bf292ee277d8a3f5d410113f8797d4915fa2b9f27fdf7e20c53274a3e550"
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
