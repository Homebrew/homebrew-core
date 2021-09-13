class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.174.0.tar.gz"
  sha256 "9be35b347fa07ac1235aa364b0e1229c00d5e98e202923d7a8a796e3ca2756ad"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "aff25f27cf63f10915f491f01a2404eb471e7c1f5a0e6215d3f663d57aa4636e"
    sha256 cellar: :any,                 big_sur:       "ee1547c7ef76a888a2a4f46d1880b3b3761be549be7bb93cfe803ae4e5eb2e42"
    sha256 cellar: :any,                 catalina:      "8c62deae5e597d7171b97ac60240d1d4ff7d40bb65bb454aae52cd2371ee8aeb"
    sha256 cellar: :any,                 mojave:        "924fb9bb84421ee725308f4fe541e3ba6a0699897a2c4c600c35a9a69ec4b2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bdd10f479f73e5e308859e2184595b096a5311cfc54ccde497545eaba05d168"
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
