class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-3.0.0.tar.gz"
  sha256 "0866adfcdc223426ba17d6133a657d94928b4f8e12392533a27387b982178373"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libflowmanager[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b5b2cf44362d857c11161d326e6b0a1721e9f2e2123351f06b242a3e3c7c0b9d" => :big_sur
    sha256 "dca4907014f0df07603f8c1bd3e6239377cd9df7fcbdccd4ffe58dbbcf3ca037" => :arm64_big_sur
    sha256 "41c5f69289236b3362062b471654f0cc9446f93d90066c001a1bda56d9b9b4f3" => :catalina
    sha256 "64843e32762b175f497e00e332bee33dbe2c5e77384ccb64a0957e9a6c2bd40b" => :mojave
    sha256 "156b302b5feade664f79f10358bc7888f9db14da53bd3549f90864b1bd9056f5" => :high_sierra
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
