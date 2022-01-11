class Htpdate < Formula
  desc "Synchronize time with remote web servers"
  homepage "https://www.vervest.org/htp/"
  url "https://www.vervest.org/htp/archive/c/htpdate-1.3.1.tar.gz"
  sha256 "f6fb63b18a0d836fda721ae5655ae0b87055db1b582e98c4700f64e1ba5e2d5a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.vervest.org/htp/?download"
    regex(/href=.*?htpdate[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45d8bc7374389aa47b3ea1701140d35ab81f11ab2e201d971adb507ae2f8917d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7c5edcab87e1ce9625721bde594472a80b9ae429230c58283a7b991a6cdbe4a"
    sha256 cellar: :any_skip_relocation, monterey:       "d716c2ac79707e5c8d2eb28fe2577bcc5ab3cea659e7b03c3e5dd7ea1b66da3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "01c2efc36b590efbf5aed5287ddd6fa11980ce6e83a97191d99bfabe929719b6"
    sha256 cellar: :any_skip_relocation, catalina:       "0d6595cfdb3bc6aa274510f03247d99aa1509a7230d8ae3200c140b3f2eb8453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eef93b8260bd3f09ab23db16a00e60dcc68a3bf08c2b9ffb1688f47a278a7f2"
  end

  # https://github.com/twekkel/htpdate/pull/9
  # remove in next release
  patch :DATA

  def install
    system "make", "prefix=#{prefix}",
                   "STRIP=/usr/bin/strip",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{sbin}/htpdate", "-q", "-d", "-u", ENV["USER"], "example.org"
  end
end

__END__
diff --git a/htpdate.c b/htpdate.c
index e25bb3c..fbed343 100644
--- a/htpdate.c
+++ b/htpdate.c
@@ -52,7 +52,7 @@
 #include <pwd.h>
 #include <grp.h>

-#if defined __NetBSD__ || defined __FreeBSD__
+#if defined __NetBSD__ || defined __FreeBSD__ || defined __APPLE__
 #define adjtimex ntp_adjtime
 #endif
