class Ifstat < Formula
  desc "Tool to report network interface bandwidth"
  homepage "http://gael.roualland.free.fr/ifstat/"
  url "http://gael.roualland.free.fr/ifstat/ifstat-1.1.tar.gz"
  sha256 "8599063b7c398f9cfef7a9ec699659b25b1c14d2bc0f535aed05ce32b7d9f507"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=["']?ifstat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c6dab0fa026b8e652bdefaf589924b6dab3ec148299090b9df4cb645aa5f7e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e47fd692e61f239ebcf2f92d7bd6bf039f5f5eed49a3ccd699cc2075125667a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b10871840559de217d7a096eccc52f9f4115be20d03eee1c17c97e60e331ac0d"
    sha256 cellar: :any_skip_relocation, ventura:        "be15673cd3ce2675c9e2e350891ad0c888c0691b53be77f649a95556ca810307"
    sha256 cellar: :any_skip_relocation, monterey:       "963b568e9888e27dbbc4b93d94231713104fbe0ea48093eb6363b719dbb773f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e78cdbeab6d2b938879ae80e9a611ea2042cf2806f9d2447b6117518d545083b"
    sha256 cellar: :any_skip_relocation, catalina:       "bc3d531dc3b4f6ff78a4acac901a9e6afc21a7994d7cbc3403839a5ae68b68b3"
    sha256 cellar: :any_skip_relocation, mojave:         "cd3e855e0608177b9aebf545faeb17a4bad84e093a8ed6a84193b9583a94dc92"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8e385a8fdf00266e63bd7a3af17cdcf07da3cb86a08bd3431cfa3b4cc88bb7a5"
    sha256 cellar: :any_skip_relocation, sierra:         "99eada14bfc555bd8f64d447bddd8a53c7325afed40446e5edbcfb5d7bdc7dd6"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e3b3f843c9fba2770a49dd7abcdacc30aa6b5e57f06b5ed96f09d20ada58bd6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80bb1ac13a6750229f428e108b349523896fa1bbe1823300f07e366e58cfa1c9"
  end

  # Fixes 32/64 bit incompatibility for snow leopard
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/ifstat", "-v"
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
