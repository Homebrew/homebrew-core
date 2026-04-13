class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  license "GPL-2.0-or-later"

  stable do
    url "https://files.libburnia-project.org/releases/libisofs-1.5.8.pl01.tar.gz"
    version "1.5.8.pl01"
    sha256 "ccbc3e7f43a0929691973539cef45f6468a3f3d72612af0b001a659957a045c7"

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
    sha256 cellar: :any,                 arm64_tahoe:   "51499f11405e131d706495a2e55f0f6e36ce0a898111e34918bccc1e659b4154"
    sha256 cellar: :any,                 arm64_sequoia: "6481f1993c2428c65c39cfb7c257f496b7d785b95618067b3d612917afc6d2d6"
    sha256 cellar: :any,                 arm64_sonoma:  "efe1ed96e030ac1aee1e2a5b84d0ffcf0cc7463840f88267489307cd62889825"
    sha256 cellar: :any,                 sonoma:        "cbb251eac3d3a0acf7b787c94be00265984ecdc84dd39fedddacdf90232d27be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03c49a76ae9abc78236c6caa06e60c7108e7236d2b5b49a7ecc54b9a24819144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7c5e53415464406c2bd683ef2ed9291b16b5b132fbfff3dc1f9fd1effae2bb"
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
