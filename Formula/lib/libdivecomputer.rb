class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.9.0.tar.gz"
  sha256 "a7b80b9083a2113a43280ee7b51d48d66ea5a779fc3fee57df7c451da0251c65"
  license "LGPL-2.1-or-later"
  head "https://github.com/libdivecomputer/libdivecomputer.git", branch: "master"

  livecheck do
    url "https://www.libdivecomputer.org/releases/"
    regex(/href=.*?libdivecomputer[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39dad657305fee0b4e643603b728a4c316395d17c0f7b88bd0919b662c25f827"
    sha256 cellar: :any,                 arm64_sequoia: "ad377c021c9476344507c25b95fdb96413bca2f0279e8dd61b75db2483058dd6"
    sha256 cellar: :any,                 arm64_sonoma:  "ac6818771fb96e7ad489c17623a6170bcf50a119d9ae8d92c47b8a295caff254"
    sha256 cellar: :any,                 arm64_ventura: "b9ad601d3cce3524e1ef177bfefc47576be3e6c04b24a8d812d032a9884ff946"
    sha256 cellar: :any,                 sonoma:        "e1aba4f43a2971def2371f2e09d0cdf1e46345d186ec0e0252cc28699e08a0ae"
    sha256 cellar: :any,                 ventura:       "d971d6e5a414e494cd320bd235577034021a7ad6fe123c9f7f2a57b9e0879b69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865c936f4b918b71680320620a856e27a210a5e5d787e3049dacaddf02580820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4b10471e85e6639f95ddfcac3e67736e9d34e726c8db0744886b6ecca25dcb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h> // for NULL macro
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
    C
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldivecomputer
    ]
    system ENV.cc, "-v", "test.c", "-o", "test", *flags
    system "./test"
  end
end
