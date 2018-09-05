class Idutils < Formula
  desc "ID database and query tools"
  homepage "https://www.gnu.org/s/idutils/"
  url "https://ftp.gnu.org/gnu/idutils/idutils-4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/idutils/idutils-4.6.tar.xz"
  sha256 "8181f43a4fb62f6f0ccf3b84dbe9bec71ecabd6dfdcf49c6b5584521c888aac2"
  revision 1

  bottle do
    sha256 "6917d20826d315163a75422d8dba2c735e6bc9d3d9b528597e2a1e7c8fb90cd5" => :mojave
    sha256 "f91b3e43aae6bb6d645a5900920364f34baae6e124b9d11f3f58a230b60d47af" => :high_sierra
    sha256 "8a3edf99858c93dda9dc51ee15efd75b9a4fd89f828c6663470ea113a814e305" => :sierra
    sha256 "49456db30e93abd2633ac358bf2e1d1e4f25b53871caecac766af9ab8d1a46b5" => :el_capitan
  end

  conflicts_with "coreutils", :because => "both install `gid` and `gid.1`"

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
    system bin/"mkid", "/usr/include"
    system bin/"lid", "FILE"
  end
end
