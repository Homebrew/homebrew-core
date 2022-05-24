class Owamp < Formula
  desc "Implementation of the One-Way Active Measurement Protocol"
  homepage "https://www.internet2.edu/products-services/performance-analytics/performance-tools/"
  url "https://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha256 "059f0ab99b2b3d4addde91a68e6e3641c85ce3ae43b85fe9435841d950ee2fb3"
  license "Apache-2.0"

  livecheck do
    # HTTP allows directory listing while HTTPS returns 403
    url "http://software.internet2.edu/sources/owamp/"
    regex(/href=.*?owamp[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c1548f42dba72b33b71fcebfae84e881ec9c298434d77715cdc49bdcf6b8a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3c656cab3adb4646e47897e27351fb92b97b9a7cd0810887567b5d1bb9a125a"
    sha256 cellar: :any_skip_relocation, monterey:       "e66ca3211d8ae8e3bd1631451f1c014f14cc933f3d1150334a3dee37db3074c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9599177f43e538b1fea107a4395cbd466ee5991e8c1d7e8d510baf32878a32a"
    sha256 cellar: :any_skip_relocation, catalina:       "a7bce114bb407f1663671ee68793b7751d512e0451cf9bbf35c1f36ad9b4c3f9"
    sha256 cellar: :any_skip_relocation, mojave:         "22833b09d6faa093c2d186560cd22e328b9ab11efa8f9774543392e7dca127f2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0ce1d8385c1cb2036acbccbcd92ed5778c8ec0aa8e4db5c06a9ea018621f58dc"
    sha256 cellar: :any_skip_relocation, sierra:         "afdeaab138caa02c535fd9d2b847c5b5b24273beef19271fc60415de16d0681f"
    sha256 cellar: :any_skip_relocation, el_capitan:     "6f86a33c176ba1394560b7707466c088930f13db102b7adc159e80e889fdc5cf"
    sha256 cellar: :any_skip_relocation, yosemite:       "fce4cc5bf0a9b5355779fb45637651f6a78bb8d3dd93bdc3ff2826b7866617fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7861b9b519cb1dd21940335fa2e904a72105938981e66637a4887db79988067b"
  end

  depends_on "i2util"

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/owping", "-h"
  end
end

__END__
diff -ur owamp-3.4/owamp/endpoint.c owamp-3.4.fixed/owamp/endpoint.c
--- owamp-3.4/owamp/endpoint.c	2014-03-21 09:37:42.000000000 -0400
+++ owamp-3.4.fixed/owamp/endpoint.c	2014-11-26 07:50:11.000000000 -0500
@@ -2188,6 +2188,11 @@
         timespecsub((struct timespec*)&wake.it_value,&currtime);

         wake.it_value.tv_usec /= 1000;        /* convert nsec to usec        */
+        while (wake.it_value.tv_usec >= 1000000) {
+            wake.it_value.tv_usec -= 1000000;
+            wake.it_value.tv_sec++;
+        }
+
         tvalclear(&wake.it_interval);

         /*
