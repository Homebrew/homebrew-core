class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "http://fallabs.com/kyototycoon/"
  url "http://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  revision 2

  bottle do
    sha256 "8ac87720e1b33402d76d26dd142abc14a3ebe211b92d97d32df7a0959a87d1d3" => :mojave
    sha256 "7be4c6e507a1d8a1d526c82c11dd41b150806211c48388ab9a0dd790875fff79" => :high_sierra
    sha256 "55a2e33c172afca9880553097beef413abce0c2f913c0ca1aa20ff5873732d14" => :sierra
    sha256 "33d857c99b29a62a42965ebd5639990cdbfeb3584adee249caff81ab0cdf4328" => :el_capitan
  end

  depends_on "kyoto-cabinet"
  depends_on "lua"

  patch :DATA if MacOS.version >= :mavericks

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-kc=#{Formula["kyoto-cabinet"].opt_prefix}",
                          "--with-lua=#{Formula["lua"].opt_prefix}"
    system "make"
    system "make", "install"
  end
end


__END__
--- a/ktdbext.h  2013-11-08 09:34:53.000000000 -0500
+++ b/ktdbext.h  2013-11-08 09:35:00.000000000 -0500
@@ -271,7 +271,7 @@
       if (!logf("prepare", "started to open temporary databases under %s", tmppath.c_str()))
         err = true;
       stime = kc::time();
-      uint32_t pid = getpid() & kc::UINT16MAX;
+      uint32_t pid = kc::getpid() & kc::UINT16MAX;
       uint32_t tid = kc::Thread::hash() & kc::UINT16MAX;
       uint32_t ts = kc::time() * 1000;
       for (size_t i = 0; i < dbnum_; i++) {
