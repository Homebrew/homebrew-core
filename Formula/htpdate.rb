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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16089cd196df79f5db3703d6e32069a804b84f771fee8f01f967f1016faa7f4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b4ad019f0bbb8fc27660db35d8624e74fcf674eae974f0f29b583a8c22a0933"
    sha256 cellar: :any_skip_relocation, monterey:       "44d98742235f59acdb4a317d6182b8f78c95ebbc3d0bea50cfa0b4923ffd203f"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e30049fa3866261ee2d20e41988e9db9ec50571be7cfd1ace56d231219fde77"
    sha256 cellar: :any_skip_relocation, catalina:       "3fe2ec701b229874425e2794221fa7740bcbd3dec4f988b5469d067db9f102ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8f689a5fc8281aded19911218b02501c17ce75df1eae2ca2a98c09fa77b2cc0"
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
