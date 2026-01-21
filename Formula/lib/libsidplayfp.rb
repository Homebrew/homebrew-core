class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.16.0/libsidplayfp-2.16.0.tar.gz"
  sha256 "81bfd58ccaa3a0ef28c903b841b4fa3014811901fd12fbb9a80b7b5d5ec2b151"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "56f6f4b8997ae4985426151b5c32859bd2189c80623e135b0d2216ed1d0f4c1e"
    sha256 cellar: :any,                 arm64_sequoia: "2ac2f97021ad57666a3812662bebad0f1ba80f5a9312695fa5fc368d951d350c"
    sha256 cellar: :any,                 arm64_sonoma:  "c4c88f789cfdaceff35e23b822d636e44f7ffe5b9fa8459fa706b97d55a87714"
    sha256 cellar: :any,                 sonoma:        "b7e7dea99fcbce1d1964df10f222d909b48eca11962b02a6e9665dd40e5f7ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c78207678a49117465d0ce2e5139bcde141891912d25c2daf0656ae2373df9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddda19558705aaededbcb67ef62b6eb221c220e63d7786d165418691267298b5"
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
