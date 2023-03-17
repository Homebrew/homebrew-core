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
    sha256 arm64_ventura:  "50b641fff2107b8de4b0e4cccaed053c249b72239f20abc0f849f8c334c34995"
    sha256 arm64_monterey: "fadb9264e692e027d98ca8e19dae4730df1a06bcb8921837ab38f61eb52c5d96"
    sha256 arm64_big_sur:  "861d6a4c5773a0291bcf908120552cc17b68943d53ef89beb9b6fb8f533819d4"
    sha256 ventura:        "fedc5283c67903b13c3179b2e4f028a0ee2607de5ea348cead64adccc68abe29"
    sha256 monterey:       "7b78ebc651efb8178eaf3baf49a8549b874187f4eda717737685513457995bc4"
    sha256 big_sur:        "286c8e5373691559b492c873152d857a37bf7d0f70c552ece315069aa8cc6d9f"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libbsd"
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
