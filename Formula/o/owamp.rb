class Owamp < Formula
  desc "Implementation of the One-Way Active Measurement Protocol"
  homepage "https://www.internet2.edu/products-services/performance-analytics/performance-tools/"
  url "https://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha256 "059f0ab99b2b3d4addde91a68e6e3641c85ce3ae43b85fe9435841d950ee2fb3"
  license "Apache-2.0"

  livecheck do
    url "https://software.internet2.edu/sources/owamp/"
    regex(/href=.*?owamp[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "408c62feb4e3c55838e9c1d60474f7e5f4879abee08e1a60ac341dc7098f4117"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9060c36f5f038c5d1b43cdb45319a414b214dc8ddef7745658b64ea756cd68e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fc9777e3da78501d8a24156a754f8fea5135e97ae89d9357bef7efa06fab6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103fa8cc22dd7993f374d851aa24dbb37369e5fa442304d3623f0015d0feb0d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07c1548f42dba72b33b71fcebfae84e881ec9c298434d77715cdc49bdcf6b8a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3c656cab3adb4646e47897e27351fb92b97b9a7cd0810887567b5d1bb9a125a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d185d38755423475b80da8ba32c38a363ee38aea467a69bf4ce782e4bdb8442"
    sha256 cellar: :any_skip_relocation, ventura:        "38c978e23ada6dd9e9441b7fb577995b830f5a01d3c548ec487991ee296899b9"
    sha256 cellar: :any_skip_relocation, monterey:       "e66ca3211d8ae8e3bd1631451f1c014f14cc933f3d1150334a3dee37db3074c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9599177f43e538b1fea107a4395cbd466ee5991e8c1d7e8d510baf32878a32a"
    sha256 cellar: :any_skip_relocation, catalina:       "a7bce114bb407f1663671ee68793b7751d512e0451cf9bbf35c1f36ad9b4c3f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77ffadd4a4b4124cc3321d7a2a86d04beba9dc525f56f0883d9d358d70c97adf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7861b9b519cb1dd21940335fa2e904a72105938981e66637a4887db79988067b"
  end

  depends_on "i2util"

  # Backport fix for newer Clang
  patch do
    url "https://github.com/perfsonar/owamp/commit/e14c6850d2e82919ca35cc591193220e4ebdc2c5.patch?full_index=1"
    sha256 "bee4e43d43acea5088d03e7822bb5166b27bf8b12b43ada8751bd2cb3cd4a527"
  end

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  patch :DATA

  def install
    # fix implicit-function-declaration error
    # reported upstream by email
    inreplace "owamp/capi.c", "#include <assert.h>", "#include <assert.h>\n#include <ctype.h>"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", "--mandir=#{man}", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"owping", "-h"
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
