class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  license "GPL-2.0-or-later"

  stable do
    url "https://files.libburnia-project.org/releases/libisofs-1.5.8.pl02.tar.gz"
    version "1.5.8.pl02"
    sha256 "10bd584d8f00d8091e814902b9f0a3e209f16e938f510fc23ba05f3fa469db5a"

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
    sha256 cellar: :any,                 arm64_tahoe:   "4caf29734bf7eb3a310526591fac0928f2acf0dfc5ebbbefa52538e86eb4cb47"
    sha256 cellar: :any,                 arm64_sequoia: "23a869971b25f3aa47b71e513a8dcd254c9454d18854e00c253eae764c7173af"
    sha256 cellar: :any,                 arm64_sonoma:  "87396de437ed3ac87b2032ea5ec5ea44a549120f17fe79b2249f42eb8455ac5e"
    sha256 cellar: :any,                 sonoma:        "03c40a2bdd94a05d62fff7347badefdff3219fd46317900bb4ba177a9e9406ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ce7c37d05ce2943118be30d4fbb8a6f88359eaa519b42479748fe23595d61a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0281b9ef58dea6c3529d3614d3aa8e8078ba4368c4d41b61ce7af6f70ea81259"
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
