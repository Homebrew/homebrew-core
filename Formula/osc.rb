class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.0.0b3.tar.gz"
  version "1.0.0b3"
  sha256 "c02d03c9327abd7a6055b8d6d7170ee57011567536f8b41dbf68b2580f7b179e"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "93144cf2161710eeee9aa2b5cf676c50e318e59231514e457144c96eb41d87d0"
    sha256 cellar: :any,                 arm64_monterey: "a83119ef9487123848841600f40ca303748c6a43362e078b874b44bbb15f3c51"
    sha256 cellar: :any,                 arm64_big_sur:  "af95c49efddcd1b3ba387e91217142cf4c768bc643ada25367aa688d22c096dd"
    sha256 cellar: :any,                 ventura:        "d1749b2dc0164cdfcf5b3cb87145ad9a9c1015fa87565363104c3f9db1e4428a"
    sha256 cellar: :any,                 monterey:       "51d26b7ba92aca0563e9a89650b5e76796dc5fbec1bcbedd726d32f02ca65b14"
    sha256 cellar: :any,                 big_sur:        "28074a56f1b8dc3d81031cbec687e95be2ca122efd7d749de4f5c179f3868a64"
    sha256 cellar: :any,                 catalina:       "b95acc4edb4e58a810dd7767acb69ad7f97b622aed911a682b8b9728ea6313f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d5d40cb379b04526e1b974bf1c727a5b74f8bdacc9e568950f249e075fcece4"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
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
