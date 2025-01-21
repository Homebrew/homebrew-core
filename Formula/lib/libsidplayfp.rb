class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.12.0/libsidplayfp-2.12.0.tar.gz"
  sha256 "bc4f4fa203dcf0736fe48c23dce9aa0db825370e5941e7595e4851efe6937cdc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ec485272ea954ac65d65dfa486b8c8bb8a750c8d9e512fbc8932534c19e9c5e"
    sha256 cellar: :any,                 arm64_sonoma:  "66d7a7105e07d9edc9fbf861f2e4a6a2910bb45fc2953c70f7f6011770b80051"
    sha256 cellar: :any,                 arm64_ventura: "6045375b29f669fddb8c36f5ab296a30b3aec238f3d45314f512d304564371f0"
    sha256 cellar: :any,                 sonoma:        "85e9084be1da3e80a63220bb6333fb067c910816a19db40ccf85a88642a5ee24"
    sha256 cellar: :any,                 ventura:       "52c66fe4af852e57a6144207bbe5929f79837114b86e4506bc0a19f5e3f4bd30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34d0b7ca32d92c58eca1bf863b232b0937691481b178b4d6e62c11dabe634b17"
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
