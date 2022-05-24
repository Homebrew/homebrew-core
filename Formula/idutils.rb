class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  license "GPL-3.0"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_monterey: "61f32269c9b9d859cb3f0951b7bcdb433e68d0a199335631ff94619ffdbe29e3"
    sha256 arm64_big_sur:  "226783d59f2f9d0d57462e16af1985c475af17ade456463c3c576804646adfe9"
    sha256 monterey:       "634de9338f14b22d4f5edc452dd828c11fed4b0753bf03fc42635f55d07d35b6"
    sha256 big_sur:        "566c400425874363c736ef591555cadffe7a09875ae5d1e07cbd1c224effbd4d"
    sha256 catalina:       "5df54c76ae786e54f6994c1c65821adaa746c8a6b1aecbafbe3cd9f4f77f7c62"
    sha256 mojave:         "b48a4caf24a1eba916f1932c85970294e56a0559603a8289fe732c124fbf0811"
    sha256 high_sierra:    "95f118aa56026de98d148bccc5a807d609a2bfc54749e1d9051a5dce80f603ef"
  end

  conflicts_with "coreutils", because: "both install `gid` and `gid.1`"

  if MacOS.version >= :high_sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/macports/macports-ports/b76d1e48dac/editors/nano/files/secure_snprintf.patch"
      sha256 "57f972940a10d448efbd3d5ba46e65979ae4eea93681a85e1d998060b356e0d2"
    end
  end

  def install
    # Work around unremovable, nested dirs bug that affects lots of
    # GNU projects. See:
    # https://github.com/Homebrew/homebrew/issues/45273
    # https://github.com/Homebrew/homebrew/issues/44993
    # This is thought to be an El Capitan bug:
    # https://lists.gnu.org/archive/html/bug-tar/2015-10/msg00017.html
    ENV["gl_cv_func_getcwd_abort_bug"] = "no" if MacOS.version == :el_capitan

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    system bin/"mkid", "#{MacOS.sdk_path}/usr/include"
    system bin/"lid", "FILE"
  end
end
