class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/0.181.0.tar.gz"
  sha256 "ef97c1454a4c8416e3bbb3e378afde85e42fe381fff8a135ddb9c8c4fedd5697"
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
