class Mac < Formula
  desc "Monkey's audio codec"
  homepage "https://www.monkeysaudio.com/"
  url "https://monkeysaudio.com/files/MAC_SDK_492.zip"
  version "4.92"
  sha256 "65170024af5c6518afdf31a3533131473a2fd29341626a315f21ce8d048ecf08"

  patch :DATA

  def install
    system "make", "-f", "./Source/Projects/NonWindows/Makefile"
    system "make", "-f", "./Source/Projects/NonWindows/Makefile", "prefix=#{prefix}", "install"
  end

  test do
    system "#{bin}/mac", test_fixtures("test.wav"), "out.ape", "-c2000"
    system "#{bin}/mac", "out.ape", "out.wav", "-d"
  end
end


__END__
--- ./Source/Projects/NonWindows/Makefile.orig
+++ ./Source/Projects/NonWindows/Makefile
@@ -3,7 +3,7 @@
 
 VERSION	  = 5
 
-CXXOPTS	  = -I Shared -I Source/Shared -I Source/MACLib -c
+CXXOPTS	  = -I Source/Shared -I Source/MACLib -c
 LDOPTS	  = -lstdc++
 
 DLLLDOPTS = -shared
