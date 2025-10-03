class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.15.1/libsidplayfp-2.15.1.tar.gz"
  sha256 "499201cc87bd6dacfd4480834c6ff0171264a22a436906d0a8bafc009db0b75c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56c69d8e4e79e2e4f85664750342cf941480436970429b0b6b6cf18a0e613d8f"
    sha256 cellar: :any,                 arm64_sequoia: "5c4534171116b0248f38a5dde4478ae31d4949b9d508bedd8326d76c43092cba"
    sha256 cellar: :any,                 arm64_sonoma:  "64c2a550065c4e5af1d3576420c0da58c15b0edb9c96a329c17498151f6b872c"
    sha256 cellar: :any,                 sonoma:        "1a9873be2f87741577ee21c6e80ddc089dfbaa9d37a262e33782660839e2abba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "215e08dd5253a2796fbd3c02ca3ef905bc34f92246e3f97002b11baed06cb289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb63c2c7be971880f59139c33a3b740e5bec9178a91e9d80b8d76aafa5a02315"
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
