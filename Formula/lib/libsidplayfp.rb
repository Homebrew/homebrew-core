class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.13.0/libsidplayfp-2.13.0.tar.gz"
  sha256 "1c09e3182dd53fc9ee37800f194f0d68e1fe06a8b5aee9abb5ab35d7bf6274b7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fe9018d70b16174c34474fffed7c243196cc2d04fef95ba95363da4e33aa36c2"
    sha256 cellar: :any,                 arm64_sonoma:  "ac7ad7579e04f30612efee23fef38f83c868b0141ed4a1a521bb330bb8c540a7"
    sha256 cellar: :any,                 arm64_ventura: "be42cbe2b491ea6cebcf1412dd7f41db2b0aad685af7e4571cca8ff446234bd1"
    sha256 cellar: :any,                 sonoma:        "ec604c5e3823bee79faef88633d6f8d157dc6cb61d6d8434736bcd820c774bd8"
    sha256 cellar: :any,                 ventura:       "6c7ba91626e4112330f2376c6fd4147cf0af95bb565a6796b83a79bb7ee34564"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0182a3553d0744947f093a557eaf953b2e32fba2c2cedf69c83c59095b68089f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f6ecaec8ff4984de531eea1240dbccce14e5ebb763705cc2b1750c2df27502"
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
