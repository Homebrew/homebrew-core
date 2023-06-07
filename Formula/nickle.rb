class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.91.tar.xz"
  sha256 "a27a063d4cb93701d2d05a5fb2895b51b28fa7a2b32463a829496fb5f63833b6"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "24c13aee47478346f64cb72fe5755f95326f02a17e5008b194089fdb67937b04"
    sha256 arm64_monterey: "4ace98b140571bfbb734fe311debb510b3d8fa7faf981cb9713b59294ad2eb83"
    sha256 arm64_big_sur:  "ac6c222ef9d544b849ff9fb1714e6e88e50ab554cac84c0814979c84ca4a37ee"
    sha256 ventura:        "64ab5c73ee1b38ac356221a008d4cde9cedf827ba104846d8f7bd3a99c42af64"
    sha256 monterey:       "5ca3c7f1821b7625aaeb3096abe9141fd2875e354d330d8701f72d9265bb128f"
    sha256 big_sur:        "e870c0478f054c72f026f331bcf02181bbac3766061f97165496b897fd81ae9e"
    sha256 catalina:       "141813d383d72a8460c63adc9501bac93632ab1489a217da691023a9d8bf14b2"
    sha256 x86_64_linux:   "e4512d3ebf15167474d7402e17be80b56751acbd31d451d3d2a75a37b98e65d4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "readline"

  uses_from_macos "bison" => :build

  # Fix build on Apple Silicon
  # Reported by email on 2022-11-09
  patch :DATA

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end

__END__
diff -pur nickle-2.91/float.c nickle-2.91-new/float.c
--- nickle-2.91/float.c	2021-08-18 19:01:45
+++ nickle-2.91-new/float.c	2022-11-09 14:33:15
@@ -1122,7 +1122,7 @@ NewDoubleFloat (double d)
     double_digit    dd;
     if (d == 0.0) RETURN (Zero);
     e = ilogb (d);
-    m = significand (d);
+    m = scalb(d, (double) -e);
     ms = Positive;
     if (m < 0)
     {
