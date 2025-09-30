class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org.ua/software/gdbm/"
  url "https://ftpmirror.gnu.org/gnu/gdbm/gdbm-1.26.tar.gz"
  mirror "https://ftp.gnu.org/gnu/gdbm/gdbm-1.26.tar.gz"
  sha256 "6a24504a14de4a744103dcb936be976df6fbe88ccff26065e54c1c47946f4a5e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "665930fdbccbaf710705195a7ee89f3b3e04122e11d585f6a50cac2ff2595296"
    sha256 cellar: :any, arm64_sequoia: "1843430b18014e91e8ad64b5ff33bef23e44350d75c6cdfa2d640f32511cc5a4"
    sha256 cellar: :any, arm64_sonoma:  "9308eb5eec8ac7b9186357ea3bc654be370735614b03c79ef4ffb8c55a5ea3a4"
    sha256 cellar: :any, arm64_ventura: "cc827cc1644fa67d7b5d56de24707e45844dce0764a911265c82982674b32ba0"
    sha256 cellar: :any, sonoma:        "bc3db54835cc359259f83e3d0b3063a9f961e6c318708fdf98c9f159789266af"
    sha256 cellar: :any, ventura:       "5b33d9eac93ab4587f19882e1e29c8534818d104984aeb6a661edc1f3afc2066"
    sha256               arm64_linux:   "bc56203964d55e8ed24b6ce88e6753301d72df6bb66ff8e92923a5e8fe128a63"
    sha256               x86_64_linux:  "4c4edca03ef3c629d9849d37084eb16afa5aaaf4b76d004f89c6f43e78af5adb"
  end

  def install
    # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
    #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
    # Use --without-readline because readline detection is broken in 1.13
    # https://github.com/Homebrew/homebrew-core/pull/10903
    args = %w[
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_path_exists testpath/"test"
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
