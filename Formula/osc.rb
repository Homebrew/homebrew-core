class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.182.0.tar.gz"
  sha256 "aafbc66f114ffcabd1c25c7f3754895a5c26608c4d8193de02382221e68403c7"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec93e87b246a7f52b6e7ef1bfde40b61a21561dd4306dc4c5a0dc889d59274f0"
    sha256 cellar: :any,                 arm64_big_sur:  "5dfad75e9c488f78623a5e270151fd2c81a4b8cc7a89054cedd8af56d0c5b76c"
    sha256 cellar: :any,                 monterey:       "7f5fc874c20ec8ddb0d3e60f736c008a9f0d1fb261e1d970a53b1c110fc60f24"
    sha256 cellar: :any,                 big_sur:        "6f1f549590562654ae2b059d76205f2307a404fe0a08e264068500bcd956ac9c"
    sha256 cellar: :any,                 catalina:       "a15a12340022d76f165ce1f6430af7f76df3323462144e5a54822876dee0d11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90a0851c25eba545e3d0b8693eed261e44c8e2a4e35a1a8e3223e9bd5b9ed90d"
  end

  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  uses_from_macos "curl"

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/2c/52/c35ec79dd97a8ecf6b2bbd651df528abb47705def774a4a15b99977274e8/M2Crypto-0.38.0.tar.gz"
    sha256 "99f2260a30901c949a8dc6d5f82cd5312ffb8abc92e76633baf231bbbcb2decb"
  end

  # upstream issue tracker, https://github.com/openSUSE/osc/issues/1101
  patch :DATA

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

__END__
diff --git a/osc/util/git_version.py b/osc/util/git_version.py
index 69022cf..67a12e4 100644
--- a/osc/util/git_version.py
+++ b/osc/util/git_version.py
@@ -3,6 +3,7 @@ import subprocess


 def get_git_archive_version():
+    return None
     """
     Return version that is set by git during `git archive`.
     The returned format is equal to what `git describe --tags` returns.
@@ -18,6 +19,7 @@ def get_git_archive_version():


 def get_git_version():
+    return None
     """
     Determine version from git repo by calling `git describe --tags`.
     """
