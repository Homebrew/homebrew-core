class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  # TODO: Check if extra `make` call can be removed at version bump.
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.11.0/getdata-0.11.0.tar.xz"
  sha256 "d16feae0907090047f5cc60ae0fb3500490e4d1889ae586e76b2d3a2e1c1b273"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_big_sur: "731e469e2d2f4de61115fc882715a9dbaf33da5f14cc89fc628a1440766738fd"
    sha256 cellar: :any,                 big_sur:       "3ee0053d39a05cadec5f4ed7edc3f143af7afd3d53b0fb7ee89b905ef7a220c6"
    sha256 cellar: :any,                 catalina:      "f133f438e1833bff0f5cf43109e27768a983a068dec90a767ba9027d2bc2f0b9"
    sha256 cellar: :any,                 mojave:        "6c5f143bb202c280c3b3e340a420a1cf6c6d936cba70faf837cd215e451987fe"
    sha256 cellar: :any,                 high_sierra:   "6b8b5f7801a6cf31ecd5ac82ee02ca344f9634ad01c235a828e3875d0354931b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef662c1fb66b8a46d82839d88417254970ff479eed33345b3d67cfec6d2c7f57"
  end

  depends_on "libtool"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-fortran",
                          "--disable-fortran95",
                          "--disable-php",
                          "--disable-python",
                          "--without-liblzma",
                          "--without-libzzip"

    ENV.deparallelize # can't open file: .libs/libgetdatabzip2-0.11.0.so (No such file or directory)
    system "make"
    # The Makefile seems to try to install things in the wrong order.
    # Remove this when the following PR is merged/resolved and lands in a release:
    # https://github.com/ketiltrout/getdata/pull/6
    system "make", "-C", "bindings/perl", "install-nodist_perlautogetdataSCRIPTS"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
