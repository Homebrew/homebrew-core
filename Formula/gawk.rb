class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  # Remove stable block when patch is no longer needed.
  stable do
    url "https://ftp.gnu.org/gnu/gawk/gawk-5.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gawk/gawk-5.2.0.tar.xz"
    sha256 "e4ddbad1c2ef10e8e815ca80208d0162d4c983e6cca16f925e8418632d639018"

    # Patch taken from:
    # https://git.savannah.gnu.org/cgit/gawk.git/patch/?id=53d97efad03453b0fff5a941170db6b7abdb2083
    # This fixes build on macOS arm64. Persistent memory allocator (PMA) is not
    # working there.
    # Remove on next release, which will supposedly come with this patch.
    patch :DATA
  end

  bottle do
    sha256 arm64_monterey: "6289d1f8da329535dcb50a610286cd4ec29225668df5d55b7d0fc25592ad4a1a"
    sha256 arm64_big_sur:  "18af9a141a7e82895f2f578d376fdecfb3924144872e9d1e86085785745f8472"
    sha256 monterey:       "21b5da026357aeb9a588da81c1170ed256fd9084fbf2fda489db3deb03bbe90c"
    sha256 big_sur:        "2e16ae3da305c804a65c41020a29fbea76bc4f8b61bb6b67a983d0dc37c8cd3b"
    sha256 catalina:       "86f7f8308a0fb9152e6272f8569f5bb9384f47a15f57c3bdd41d6334838fe74b"
    sha256 x86_64_linux:   "29b8be1d8bb275b8a82747490c29472fea3a7fc0b4bd345c0c72f3abe8c4b4be"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  conflicts_with "awk",
    because: "both install an `awk` executable"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end

__END__
--- a/configure
+++ b/configure
@@ -12722,8 +12722,18 @@ fi
 
 			;;
 		*darwin*)
-			LDFLAGS="${LDFLAGS} -Xlinker -no_pie"
-			export LDFLAGS
+			# 30 September 2022: PMA works on Intel but not
+			# on M1, disable it, until it gets fixed
+			case $host in
+			x86_64-*)
+				LDFLAGS="${LDFLAGS} -Xlinker -no_pie"
+				export LDFLAGS
+				;;
+			*)
+				# aarch64-*
+				use_persistent_malloc=no
+				;;
+			esac
 			;;
 		*cygwin* | *CYGWIN* | *solaris2.11* | freebsd13.* | openbsd7.* )
 			true	# nothing do, exes on these systems are not PIE
