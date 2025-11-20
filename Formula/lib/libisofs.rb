class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  url "https://files.libburnia-project.org/releases/libisofs-1.5.6.pl01.tar.gz"
  version "1.5.6"
  sha256 "ac1fd338d641744ca1fb1567917188b79bc8c2506832dd56885fec98656b9f25"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://files.libburnia-project.org/releases/"
    regex(/href=.*?libisofs[._-]v?(\d+(?:\.\d+)+)(?:[._-]pl\d+)?\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "1e22e5ca79d8f4b991400c72d5300d9fcd5020ed43f54749ddb357d9ddd406cd"
    sha256 cellar: :any,                 arm64_sequoia:  "c4321671d1170bb88b23b8bf3e14dd9046d025341fb428a640c705cf5f8934ee"
    sha256 cellar: :any,                 arm64_sonoma:   "34b5564fd603417946cc498df54e7b8b59380b08259728709446efd2be7680c5"
    sha256 cellar: :any,                 arm64_ventura:  "3ecb31fd37dae4b455187e9fafc86b965d76d998a011b9559bd3bf4b6a422e77"
    sha256 cellar: :any,                 arm64_monterey: "3c9c7c449618b5c4325821877d77d30797b2f972c7247918efeb60456cb99c47"
    sha256 cellar: :any,                 arm64_big_sur:  "bd20a575b9908265074276c6e008a7885dda3d5818da99e4714141da1461d205"
    sha256 cellar: :any,                 sonoma:         "56e6b4f827a9c2b3a3a2a4773a89bac741567e242a5b69fad9b2d02aac33ee34"
    sha256 cellar: :any,                 ventura:        "c04b4a231f71dccffcca4e4fade48e05c898e22860dc73630c8326dcc5688d23"
    sha256 cellar: :any,                 monterey:       "fee8ce45cc44667d25010c2fcb268e4c9e3c3a0200330618513ca3eaad19cb58"
    sha256 cellar: :any,                 big_sur:        "30b05cc10a096c6c8ba9a04b4884a83690abe966cb9604b85fb2cd139e572b46"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "30460b05ad9372e8086785db2582b2d9103e52cfc1b3294bd4bbb208d4a852c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d23202a09bdce26182a94e00cc3c412373f30a7396dbe73d6abf2dcd21d5ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "libzip"

  def install
    # use gnu libtool instead of apple libtool
    inreplace "bootstrap", "libtool", "glibtool"
    # regenerate configure as release uses old version of libtool
    # which causes flat_namespace
    system "./bootstrap"

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <libisofs/libisofs.h>

      int main() {
        int major, minor, micro;
        iso_lib_version(&major, &minor, &micro);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lisofs", "-o", "test"
    system "./test"
  end
end
