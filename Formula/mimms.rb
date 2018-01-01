class Mimms < Formula
  include Language::Python::Virtualenv

  desc "Mms stream downloader"
  homepage "https://savannah.nongnu.org/projects/mimms"
  url "https://launchpad.net/mimms/trunk/3.2.1/+download/mimms-3.2.1.tar.bz2"
  sha256 "92cd3e1800d8bd637268274196f6baec0d95aa8e709714093dd96ba8893c2354"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c3e7cc6b99acb9af2a0e80029f0f0e7e4714430e21af830ee5ec59cbd6c1e447" => :high_sierra
    sha256 "a594aa43b8705e1fd8945ba78b9374eb82c805cc75e92a4ea10375fb8b443529" => :sierra
    sha256 "9996da3980f7307ef745866b671fc56045dc951ff48333ea4e121acaa2d476ae" => :el_capitan
    sha256 "88b2e83cfdf9abca4ff712bddacb76611ce29aa2c58218c05e8abf3ed7d0be2b" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "libmms"

  # Switch shared library loading to Mach-O naming convention (.dylib)
  # Matching upstream bug report: https://savannah.nongnu.org/bugs/?29684
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mimms", "--version"
  end
end

__END__
diff --git a/libmimms/libmms.py b/libmimms/libmms.py
index fb59207..ac42ba4 100644
--- a/libmimms/libmms.py
+++ b/libmimms/libmms.py
@@ -23,7 +23,7 @@ exposes the mmsx interface, since this one is the most flexible.
 
 from ctypes import *
 
-libmms = cdll.LoadLibrary("libmms.so.0")
+libmms = cdll.LoadLibrary("libmms.0.dylib")
 
 # opening and closing the stream
 libmms.mmsx_connect.argtypes = [c_void_p, c_void_p, c_char_p, c_int]
