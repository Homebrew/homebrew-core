class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.8.0.tar.gz"
  sha256 "275ecce7923644ed581faab9dcb4f1a69ad251bceb0721c4e5f85fb631617a0e"
  license "LGPL-2.1-or-later"
  head "https://github.com/libdivecomputer/libdivecomputer.git", branch: "master"

  livecheck do
    url "https://www.libdivecomputer.org/releases/"
    regex(/href=.*?libdivecomputer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "2d1fcffb41e208dda7721558578c6c6f212d758b9782449ce1f800d89e05c1cb"
    sha256 cellar: :any,                 arm64_sonoma:   "8dd4c53baa97fba521444635e28477af5651cb22ab242ce6a6cb3725175b7056"
    sha256 cellar: :any,                 arm64_ventura:  "94af44c0b407fae8f45e0d5f5fb86fe92f5464efe57d316eb71526aa68eac264"
    sha256 cellar: :any,                 arm64_monterey: "84b1aab56409e9842deab38dab5dc8a9f7ddd1c7f0ea5ad68b9bcd31733645fb"
    sha256 cellar: :any,                 arm64_big_sur:  "dadcbc9e4225a70a0a508f68d69dd033cd4c146eed0a8b35c9ab4f6883111683"
    sha256 cellar: :any,                 sonoma:         "1e6e3c6a14b6a9bdfa7cd4c28b37926409820fb356db44e697f4cb57fcd4273b"
    sha256 cellar: :any,                 ventura:        "5a831d39e6851ac0f0aa879321f2da7734f40b6f0b66f9824c59766547ed4857"
    sha256 cellar: :any,                 monterey:       "03dd6bece702dbd9128822bc7e58bffaa7ddbab2e1c154416c8843068ddc9512"
    sha256 cellar: :any,                 big_sur:        "0daa371bb5f9f96bd3c2c02f02181f77004e5326d4975e04fd441d01593c6f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a564c1072cacd56aacdeddb41032cce203e2d59cf375448e160007c619204245"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdivecomputer/context.h>
      #include <libdivecomputer/descriptor.h>
      #include <libdivecomputer/iterator.h>
      int main(int argc, char *argv[]) {
        dc_iterator_t *iterator;
        dc_descriptor_t *descriptor;
        dc_descriptor_iterator(&iterator);
        while (dc_iterator_next(iterator, &descriptor) == DC_STATUS_SUCCESS)
        {
          dc_descriptor_free(descriptor);
        }
        dc_iterator_free(iterator);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldivecomputer
    ]
    system ENV.cc, "-v", "test.c", "-o", "test", *flags
    system "./test"
  end
end
