class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.177.0.tar.gz"
  sha256 "3dfeb9944f78f17a509966dd1dd89d177dd0d87856a6c8f7556d68e07521d1d4"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8cbbb5e963a05080ecff592388d59e896333d41f7f8416fa9670690e582a2a1a"
    sha256 cellar: :any,                 arm64_big_sur:  "0c5e7c3eb32f6492fa802351eef8c6d3ecd98568bc42e7c7f468d4bfe5c486e9"
    sha256 cellar: :any,                 monterey:       "6bcf28372b0620ee54688ac0bc31e6146aa217aec8f35b073cdad349cf320caf"
    sha256 cellar: :any,                 big_sur:        "4948b942f82eb690022ecf628ef6983e70c0024e7e4ce23265e757f93ba0b1c8"
    sha256 cellar: :any,                 catalina:       "852e256e0f08cc623fe93fed986f9438806ed29024fa5731c87eef0e39977c68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e3f5a16b0e44dd9b079e9040221fa607c3511fe50308144a643455c1ec6ce6b"
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
