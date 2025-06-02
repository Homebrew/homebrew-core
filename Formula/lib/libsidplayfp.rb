class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.14.0/libsidplayfp-2.14.0.tar.gz"
  sha256 "0f49c87c3a4791b9709d502e605274ee5c4c20eabfdea0340917d27cbd685f53"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1079c7fdb8d53199b128d5022a0ad918cd937bbf1535e2b73f030e560540f783"
    sha256 cellar: :any,                 arm64_sonoma:  "6d3c978c8bab5665aa97a7d78f9c3f13865a87e01615c89f2b2a466ff6e61a65"
    sha256 cellar: :any,                 arm64_ventura: "b4d96ddf0760fa704d6d183628e80b273a5f51c2115f4b8e70979856a965750e"
    sha256 cellar: :any,                 sonoma:        "a29f5db031283a1a9605d9c41d66f1d39f3dbfdb4a9b20c207b2651576241192"
    sha256 cellar: :any,                 ventura:       "f1fa12831c8b3bf2d5d6e633cc312a90bec47c5c3b3d2b72bdb1ad48a421727f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a68214b7de4632c51b0db5bfce208238b948b4733635dbaf27da0aa0c302d4db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d98612cce385b91aec0ba7ae4c0ae1349be0eb4012bef57d872d92cff2dfdaa4"
  end

  head do
    url "https://github.com/libsidplayfp/libsidplayfp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "coreutils" => :build
    depends_on "libtool" => :build
    depends_on "xa" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libgcrypt"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <sidplayfp/sidplayfp.h>

      int main() {
          sidplayfp play;
          std::cout << LIBSIDPLAYFP_VERSION_MAJ << "."
                    << LIBSIDPLAYFP_VERSION_MIN << "."
                    << LIBSIDPLAYFP_VERSION_LEV;
          return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-I#{include}", "-lsidplayfp", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
