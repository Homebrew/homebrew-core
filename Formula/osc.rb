class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.176.0.tar.gz"
  sha256 "9cef44e1c27e423f33c3b03dbfa74433042cce063ffbbc5ead82c74dac9917b2"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b1bb6399a8354b54ec662312050225f4a930ca5e84ff0c92727df410ca25235e"
    sha256 cellar: :any,                 arm64_big_sur:  "968b82656b91621ef571880ae7998983fea24799216844027cd63f43760d1dde"
    sha256 cellar: :any,                 monterey:       "c272b3e8927e3007f1c5f0103907622441231154b1ff2d452a21e67593dfe05c"
    sha256 cellar: :any,                 big_sur:        "47e13a499a78af0b3cee0d71b5c5bb959a453d42f1ac1cf9e91a408ac6805da1"
    sha256 cellar: :any,                 catalina:       "c3eb01e94ec3160f91086673286935de0e9f0867217a4f20357f4b06ed692419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948efff33f57394d660641f6f05c43452d0af7974c936a7c08e5e05d178b3007"
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
