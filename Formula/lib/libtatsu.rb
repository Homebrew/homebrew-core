class Libtatsu < Formula
  desc "Library handling the communication with Apple's Tatsu Signing Server (TSS)"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libtatsu/releases/download/1.0.5/libtatsu-1.0.5.tar.bz2"
  sha256 "536fa228b14f156258e801a7f4d25a3a9dd91bb936bf6344e23171403c57e440"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libtatsu.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4733e91bdb7fdcd93e030fc7a36174bfb8bc4f4e489270a47a5d5d70d0d9376c"
    sha256 cellar: :any,                 arm64_sequoia: "e729a89bd9fba8be9355e7c4dd4dfc89cb039f6c063ffcd1adb102d3dfec75d5"
    sha256 cellar: :any,                 arm64_sonoma:  "efb9b3d41f8e825551a9047fd46788477ee53b3fa40f1c032bb74297be7ca21b"
    sha256 cellar: :any,                 arm64_ventura: "6324074e98eef39e5bccff4ed8dccd26cd28279d6cfeeb907e48ef8770bdc5bc"
    sha256 cellar: :any,                 sonoma:        "3c64e4c3dec2b31b5d9a228073f08997d2efa813fe6ec431eba870112995fa08"
    sha256 cellar: :any,                 ventura:       "73f65e3ab29de1deaa39d6784e9003867ba43205e91cede4847239f118bd7ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be22c10c322aac3a41282d50b06cd6c8d3add347ba1f9978a3fc43da5418a753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e616827b2db64dfa913646990030b20db78dc3cddd6e56a801eb82658ae6b07"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  uses_from_macos "curl"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libtatsu/tss.h"

      int main(int argc, char* argv[]) {
        tss_set_debug_level(0);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ltatsu", "-o", "test"
    system "./test"
  end
end
