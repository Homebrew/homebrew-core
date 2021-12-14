class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
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
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
