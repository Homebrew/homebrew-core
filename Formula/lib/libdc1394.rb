class Libdc1394 < Formula
  desc "Provides API for IEEE 1394 cameras"
  homepage "https://damien.douxchamps.net/ieee1394/libdc1394/"
  url "https://downloads.sourceforge.net/project/libdc1394/libdc1394-2/2.2.7/libdc1394-2.2.7.tar.gz"
  sha256 "537ceb78dd3cef271a183f4a176191d1cecf85f025520e6bd3758b0e19e6609f"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "334905f44916998f84a6b1a24bb52253e2353d7ed2dfe454b0f292cdfba535b7"
    sha256 cellar: :any,                 arm64_sequoia: "ba66548f7e17020550447fda651d518994c0fd6603c196a5f191545d1d865356"
    sha256 cellar: :any,                 arm64_sonoma:  "1fea647769f1bcbe75819eca994b865c7f039a28485d9675e39ad1b14ca0360a"
    sha256 cellar: :any,                 sonoma:        "190bf71276b8710d016a1ba4d33d4d6553ff8320d7ed650c52af2dda0534f120"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d1661d801921d5cca22436721730532f122e8e62a9bb04ad9766b55d22f3ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bd27943334a6a6da194dbe3b765abe66d65622b15a420403052606f92c0a764"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libusb"
  end

  # fix issue due to bug in OSX Firewire stack
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libdc1394/capture.patch"
    sha256 "6e3675b7fb1711c5d7634a76d723ff25e2f7ae73cd1fbf3c4e49ba8e5dcf6c39"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-examples",
                          "--disable-sdltest",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dc1394/dc1394.h>

      int main(void) {
        dc1394error_t err;
        dc1394_t * d;
        dc1394camera_list_t * list;

        d = dc1394_new();
        if(!d)
          return 1;

        err = dc1394_camera_enumerate(d, &list);
        DC1394_ERR_RTN(err, "Failed to enumerate cameras");

        dc1394_camera_free_list(list);
        dc1394_free(d);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ldc1394"
    system "./test"
  end
end
