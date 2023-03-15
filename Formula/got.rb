class Got < Formula
  desc "Version control system"
  homepage "https://gameoftrees.org/"
  url "https://gameoftrees.org/releases/portable/got-portable-0.86.tar.gz"
  sha256 "1478cb124c6cbe4633e2d2b593fa4451f0d3f6b7ef37e2baf2045cf1f3d5a7b0"
  license "ISC"

  livecheck do
    url "https://gameoftrees.org/releases/portable/"
    regex(/href=.*?got-portable[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "339a85763e5d156ebd7213c03edc50098152222a02115525b462660d9e8d59d9"
    sha256 arm64_monterey: "74597ad0b1eb82500dd64c211c533892dcac7023f8e1337af284b5ff76c1265e"
    sha256 arm64_big_sur:  "55e69002961b8f4024f621c60ab0d8a957be97d48b8186298731010300be2273"
    sha256 ventura:        "ad6cfe811c11b01624d849a095c69f2dd570a160c8ca1eba4ee0c9ace01d83d0"
    sha256 monterey:       "1b352bf5e1328f37f336c4c8a93bf7c9da4516afdc263c10c3f3b6af6a8d7105"
    sha256 big_sur:        "49735451b6890c319fedc6798acd01ec60b7a7d13610c4fc6022271bc7c0c74b"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on :macos # FIXME: build fails on Linux.
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libmd"
    depends_on "util-linux" # for libuuid
  end

  # Avoid the `compat/getopt.c` placeholder and use the system's version.
  # Reported to the upstream mailing list at
  #   https://lists.openbsd.org/cgi-bin/mj_wwwusr?func=lists-long-full&extra=gameoftrees
  patch :DATA

  def install
    # The `configure` script hardcodes our `openssl@3`, but we can't use it due to `libevent`.
    inreplace "configure", %r{\$\{HOMEBREW_PREFIX?\}/opt/openssl@3}, Formula["openssl@1.1"].opt_prefix
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    ENV["GOT_AUTHOR"] = "Flan Hacker <flan_hacker@openbsd.org>"
    system bin/"gotadmin", "init", "repo.git"
    mkdir "import-dir"
    %w[haunted house].each { |f| touch testpath/"import-dir"/f }
    system bin/"got", "import", "-m", "Initial Commit", "-r", "repo.git", "import-dir"
    system bin/"got", "checkout", "repo.git", "src"
  end
end

__END__
diff --git a/include/got_compat2.h b/include/got_compat2.h
index ec546e4b..54e01a99 100644
--- a/include/got_compat2.h
+++ b/include/got_compat2.h
@@ -390,7 +390,7 @@ int scan_scaled(char *, long long *);
 #define FMT_SCALED_STRSIZE	7  /* minus sign, 4 digits, suffix, null byte */
 #endif
 
-#ifndef HAVE_LIBBSD
+#if !defined(HAVE_LIBBSD) && !defined(__APPLE__)
 /* getopt.c */
 extern int	BSDopterr;
 extern int	BSDoptind;
