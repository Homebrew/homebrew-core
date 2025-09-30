class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "https://gitlab.xiph.org/xiph/libao/-/archive/1.2.2/libao-1.2.2.tar.gz"
  sha256 "df8a6d0e238feeccb26a783e778716fb41a801536fe7b6fce068e313c0e2bf4d"
  license "GPL-2.0-or-later"
  head "https://gitlab.xiph.org/xiph/libao.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 arm64_tahoe:    "e5015eef806ec149f9ad6e502d1aed412e9746da6f5ba2fa23947a5e58641d0b"
    sha256 arm64_sequoia:  "18630c73a7d4187e4ed527096e9450a4d26bcc4a5918bf94656fe641be16922a"
    sha256 arm64_sonoma:   "c3252aa3672c5a52882ad70a94219a4284b53415d996ebd21b334ea063ff4e58"
    sha256 arm64_ventura:  "cca7befa22b09e8ecfb3746d8c6de3cd1a519cf76ab970c8e78acde4dd92cef3"
    sha256 arm64_monterey: "87276ccd471ed61409cc6b1fc45b33e3b9ae60414695629cb519a2d7f03bb7e4"
    sha256 arm64_big_sur:  "4ffbc11b951c7c833881d1a60d20d8969e30bfb85e817b660e38a3fc581ccb9c"
    sha256 sonoma:         "f6cb690857cde255ac71d09df367afc6de502bd9e7f27081e55116d9e174a075"
    sha256 ventura:        "9eda661b1d28f5da8c205660cf2c2b9a4ad71d086c39b186cb12d18ff81f9551"
    sha256 monterey:       "14bc27effce651df160ad5efbb377773479c6ea28b65f585760aa5316c3dc6ad"
    sha256 big_sur:        "f27a782e33661e2aa75cbfcbe775a2da08f7f781c6e7608e8f1e3a4a354c4cde"
    sha256 catalina:       "b6ccd4915aa272b58f267995ce3c87ad42388926535fedea0243c9b0b9941089"
    sha256 arm64_linux:    "4afd643a9b5267277711e6d28a42d52f0bf7968d3973d3e325b4681a0b966929"
    sha256 x86_64_linux:   "bdb709d63e9de2e2dc947887fdc3a383b626d24c200cf80ce58eeaffa5ff7eb2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    ENV["AUTOMAKE_FLAGS"] = "--include-deps"
    system "./autogen.sh"
    system "./configure", "--enable-static", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ao/ao.h>
      int main() {
        ao_initialize();
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lao", "-o", "test"
    system "./test"
  end
end
