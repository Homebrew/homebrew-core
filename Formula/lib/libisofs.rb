class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  license "GPL-2.0-or-later"

  stable do
    url "https://files.libburnia-project.org/releases/libisofs-1.5.6.pl01.tar.gz"
    version "1.5.6.pl01"
    sha256 "ac1fd338d641744ca1fb1567917188b79bc8c2506832dd56885fec98656b9f25"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url "https://files.libburnia-project.org/releases/"
    regex(/href=.*?libisofs[._-]v?(\d+(?:\.\d+)+(?:[._-]pl\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e1fbe54b14ab090312efb7e87b22e59e1914f20f70b11f2dae9ba31f7a36bc9b"
    sha256 cellar: :any,                 arm64_sequoia: "653342c516c2cfabf4b40bce418ba706a3e7a218a8872f4be37c5ca227c0cf69"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb0fdec1618c88fc89901a15571c486547bcaea4f32e4f52fb99808daf4bf3b"
    sha256 cellar: :any,                 sonoma:        "cffe8b203438edfedda9d7a3490c05f8223a06189b8ab6dcc38aad72fb65020d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "460614b2690b6a47bffd1fb5b61add40d6b6ace8df09a5b8f0d8edc94c6691d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ba65052f0f50669ffaddaa72ef94e575909ddea93ee60ac745d743bf4c7a875"
  end

  head do
    url "https://dev.lovelyhq.com/libburnia/libisofs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "libzip"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      # use gnu libtool instead of apple libtool
      inreplace "bootstrap", "libtool", "glibtool"
      # regenerate configure as release uses old version of libtool
      # which causes flat_namespace
      system "./bootstrap"
    end

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
