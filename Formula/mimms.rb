class Mimms < Formula
  desc "Mms stream downloader"
  homepage "https://savannah.nongnu.org/projects/mimms"
  url "https://launchpad.net/mimms/trunk/3.2.1/+download/mimms-3.2.1.tar.bz2"
  sha256 "92cd3e1800d8bd637268274196f6baec0d95aa8e709714093dd96ba8893c2354"

  bottle do
    cellar :any_skip_relocation
    sha256 "24e4df14c313ddf76122bef62c9eb68d12ef5e7cc4cfe7f6c9effa2eb65710ba" => :el_capitan
    sha256 "c260595a5f7382b7665b5a1e943a7ad72d781d0777b6b31a0c2f6a8a96ae95af" => :yosemite
    sha256 "cd2bcde21ce30010034d006883fc72b02795e0e5f544294c0d0bf275264e231b" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libmms"

  # Switch shared library loading to Mach-O naming convention (.dylib)
  # Matching upstream bug report: https://savannah.nongnu.org/bugs/?29684
  patch :DATA

  def install
    ENV["PYTHONPATH"] = lib+"python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{prefix}"
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
