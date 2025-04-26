class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.13.1/libsidplayfp-2.13.1.tar.gz"
  sha256 "adda6ce516d6a61e741bcf390d85a0afc72a51c9ff342ff93bb522d4af2f7cd4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a08182d0154c8a2ee3d8612aefcbe99c9e031a01e8e611edb0788422ee55df8c"
    sha256 cellar: :any,                 arm64_sonoma:  "50df29ce9c4db2c980847477b517ed87fff0272b1daf6f736134e4f1a8d99d93"
    sha256 cellar: :any,                 arm64_ventura: "468899ecea582754df6d155838978bc42e5d91b05b6ee528d97ae4b988d675d1"
    sha256 cellar: :any,                 sonoma:        "606df70c23d4ee651b101ffb72331c8a6a202925b982ba6f11a2ece3fae67a2b"
    sha256 cellar: :any,                 ventura:       "527afccbd807e0e9a5dd293c1ba31f0a3f6a7eb6383050a8fbd00496eade31cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7cf82e34aa6eb058860458f7d0eb622f8397f72868374977a3861bbe700ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef7cde3a67b18b5c5f0cd13618046ceca62c785079d034adf2e61ce92b3e72ba"
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
