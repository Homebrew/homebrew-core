class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.7.0.tar.gz"
  sha256 "80d9f194ea24502039df98598482e0afc6b0e333de79db34c29b2d68934d25b9"
  license "LGPL-2.1-or-later"
  head "https://github.com/libdivecomputer/libdivecomputer.git", branch: "master"

  livecheck do
    url "https://www.libdivecomputer.org/releases/"
    regex(/href=.*?libdivecomputer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2a7bd7af77fe467bda4a336616f3e1e8a054b8481b97bd5f5b9507f265318e83"
    sha256 cellar: :any,                 arm64_big_sur:  "c5f918bf0cf0716949639440453e31eb929a918d5328fb1d4dd50ad6f6a497a5"
    sha256 cellar: :any,                 monterey:       "e60b9733a86f7f911241780c4b12619c33850e152c816adbf9893f48e17d82cb"
    sha256 cellar: :any,                 big_sur:        "80a648490411d90cee0ae9bbafbc91e48e6ee1d4b449bfad5795cd375b5337d0"
    sha256 cellar: :any,                 catalina:       "b0e1c5af39a3a474f72a89b669acfd82628f91aabe21c719e2eee78dc0099950"
    sha256 cellar: :any,                 mojave:         "79ea433c1787070be036fa259b1cb7bd673d5c787ac937291361711d967708d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a241ae2fd6589976993f2ac0fea3114a1131514f6bafcace961a53c28658da"
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
