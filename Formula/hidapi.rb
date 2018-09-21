class Hidapi < Formula
  desc "Library for communicating with USB and Bluetooth HID devices"
  homepage "https://github.com/signal11/hidapi"
  url "https://github.com/signal11/hidapi/archive/hidapi-0.8.0-rc1.tar.gz"
  sha256 "3c147200bf48a04c1e927cd81589c5ddceff61e6dac137a605f6ac9793f4af61"
  head "https://github.com/signal11/hidapi.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "8d436545e94c2dc7a1c14964ca399e2919c51d02a67b115e266bfa626988436f" => :mojave
    sha256 "c534434485aeac388fa1ab7223264ceb9915c4c8aa3815895939d9d6c2fd13b0" => :high_sierra
    sha256 "2c16239b99b23f5fee3992391f8450a317b3c421d61efd248ad69c063cb7ffef" => :sierra
    sha256 "cea4750ae62177a9b399b43d463eec41852161f691a148b03d7b7f91789932fc" => :el_capitan
    sha256 "06daf7b3080f0c87c46b3f69c869ce3b88de5ce1187db2435cd8e3a1db2e9871" => :yosemite
    sha256 "6821097f8a0bb55df7697aa26fc7bea3e79914e76932eb69e03b4346a22309dc" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # This patch addresses a bug discovered in the HidApi IOHidManager back-end
  # that is being used with Macs.
  # The bug was dramatically changing the behaviour of the function
  # "hid_get_feature_report". As a consequence, many applications working
  # with HidApi were not behaving correctly on OSX.
  # pull request on Hidapi's repo: https://github.com/signal11/hidapi/pull/219
  patch do
    url "https://github.com/signal11/hidapi/pull/219.patch?full_index=1"
    sha256 "c0ff6eb370d6b875c06d72724a1a12fa0bafcbd64b2610014abc50a516760240"
  end

  def install
    system "./bootstrap"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bin.install "hidtest/.libs/hidtest"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "hidapi.h"
      int main(void)
      {
        return hid_exit();
      }
    EOS

    flags = ["-I#{include}/hidapi", "-L#{lib}", "-lhidapi"] + ENV.cflags.to_s.split
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
