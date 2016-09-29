class Ifstat < Formula
  desc "Tool to report network interface bandwidth"
  homepage "http://gael.roualland.free.fr/ifstat/"
  url "http://gael.roualland.free.fr/ifstat/ifstat-1.1.tar.gz"
  sha256 "8599063b7c398f9cfef7a9ec699659b25b1c14d2bc0f535aed05ce32b7d9f507"

  bottle do
    cellar :any_skip_relocation
    sha256 "99eada14bfc555bd8f64d447bddd8a53c7325afed40446e5edbcfb5d7bdc7dd6" => :sierra
    sha256 "e3b3f843c9fba2770a49dd7abcdacc30aa6b5e57f06b5ed96f09d20ada58bd6f" => :el_capitan
    sha256 "ecce408a9ae1a82c7b2457e5a5263ec760096e7e0e71cf0da1ce98523787bcbc" => :yosemite
    sha256 "9107e6b49f17fc1a4eac3ded9e499d164fe73f1c8d9307146b9db00952a72de9" => :mavericks
  end

  # Fixes 32/64 bit incompatibility for snow leopard
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end

__END__
diff --git a/drivers.c b/drivers.c
index d5ac501..47fb320 100644
--- a/drivers.c
+++ b/drivers.c
@@ -593,7 +593,8 @@ static int get_ifcount() {
   int ifcount[] = {
     CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_SYSTEM, IFMIB_IFCOUNT
   };
-  int count, size;
+  int count;
+  size_t size;
   
   size = sizeof(count);
   if (sysctl(ifcount, sizeof(ifcount) / sizeof(int), &count, &size, NULL, 0) < 0) {
@@ -607,7 +608,7 @@ static int get_ifdata(int index, struct ifmibdata * ifmd) {
   int ifinfo[] = {
     CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_IFDATA, index, IFDATA_GENERAL
   };
-  int size = sizeof(*ifmd);
+  size_t size = sizeof(*ifmd);
 
   if (sysctl(ifinfo, sizeof(ifinfo) / sizeof(int), ifmd, &size, NULL, 0) < 0)
     return 0;

