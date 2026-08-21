class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libcddb/libcddb/1.3.2/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  license "LGPL-2.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f0a1bd45cdf2b26cc99ab0206abb9cbbe41f2d76b7f15e19be180a4d36c46291"
    sha256 cellar: :any, arm64_sequoia: "88b9e48b5e68d994010a18cfda8862b7bd561c85814e23d01fdb3384a3da3951"
    sha256 cellar: :any, arm64_sonoma:  "a3d83ba8561cabef84fb98eb97f270aea3770da1420ba460267faa6fb47864d6"
    sha256 cellar: :any, sonoma:        "1d0899b18cfd4aa5c68b5378d7b13a18d8dc2dea9ce43c8cb32bce3016800a9a"
    sha256 cellar: :any, arm64_linux:   "e948881758d30afcd4fce9291384cf3d669534a1fdabea6edcaf1372a98eb659"
    sha256 cellar: :any, x86_64_linux:  "21fb0f06d53ff95e28280df8a7f49d9614e98e3ae62d44f6e2bc0e2a4cfd5053"
  end

  depends_on "pkgconf" => :build
  depends_on "libcdio"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cddb/cddb.h>
      int main(void) {
        cddb_track_t *track = cddb_track_new();
        cddb_track_destroy(track);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcddb", "-o", "test"
    system "./test"
  end
end
