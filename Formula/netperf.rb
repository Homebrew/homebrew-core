class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "https://hewlettpackard.github.io/netperf/"
  url "https://github.com/HewlettPackard/netperf/archive/netperf-2.7.0.tar.gz"
  sha256 "4569bafa4cca3d548eb96a486755af40bd9ceb6ab7c6abd81cc6aa4875007c4e"
  head "https://github.com/HewlettPackard/netperf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "cf086e0d276a572aba8318f7080cedc94b36a7b612cdbb4bcc3ceefef0080c53" => :high_sierra
    sha256 "4d3f648081c84ad697d608b56bcfce3237de7c34c4e4a53d9851628f9d50cd5d" => :sierra
    sha256 "c6e96625b1f83a7f83d3c9b53b8584ab65d73cfd59bc38672588ba82d37ecc1d" => :el_capitan
  end

  # We need the patch to build with demo mode on OSX. This is already fixed in
  # upstream git, but no release has been made since.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-demo",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end

__END__
--- a/src/netlib.c	2015-07-20 18:39:35.000000000 +0100
+++ a/src/netlib.c	2016-02-08 11:34:16.000000000 +0000
@@ -4000,7 +4000,7 @@
 #ifdef WIN32
 __forceinline void demo_interval_display(double actual_interval)
 #else
-  inline void demo_interval_display(double actual_interval)
+  void demo_interval_display(double actual_interval)
 #endif
 {
   static int count = 0;
@@ -4067,7 +4067,7 @@
    inline directive has to appear in netlib.h... */
 void demo_interval_tick(uint32_t units)
 #else
-  inline void demo_interval_tick(uint32_t units)
+  void demo_interval_tick(uint32_t units)
 #endif
 {
   double actual_interval = 0.0;
