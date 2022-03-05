class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.176.0.tar.gz"
  sha256 "9cef44e1c27e423f33c3b03dbfa74433042cce063ffbbc5ead82c74dac9917b2"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ab27f937fc3bcc9235d7ffcaec76b1cf12ff368f0f0e7f1cc9d73b79a5c5db2"
    sha256 cellar: :any,                 arm64_big_sur:  "df09bfb5277f1d115dfe753afb1ac4e667f7164802b17ef0ee75564e526a6f80"
    sha256 cellar: :any,                 monterey:       "15fce4e0db6c44a54239945b86c1c4343a9394ba742d9597c278e6bdc11d5dde"
    sha256 cellar: :any,                 big_sur:        "1fc999d3f4b04721d465205df8ae42d75c5a40cff42dd31e13ac1d9b6425f9a5"
    sha256 cellar: :any,                 catalina:       "99f95721962321eb11cfd07e53a23187fc40b2f170561959c4a7190b2cfac94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f423fbc8ca7b67644cecf42d744e90f552ae9744aa39ffc1164026e78b1843"
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
