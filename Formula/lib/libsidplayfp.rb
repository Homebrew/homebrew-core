class Libsidplayfp < Formula
  desc "Library to play Commodore 64 music"
  homepage "https://github.com/libsidplayfp/libsidplayfp"
  url "https://github.com/libsidplayfp/libsidplayfp/releases/download/v2.15.0/libsidplayfp-2.15.0.tar.gz"
  sha256 "42c28b9ef57998ad66bbbb3dfab00c6684715c643d9ccc9ac8da4d7cf296dd00"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "732b3b6b22195c382a7f8ead894e06818a2e1715a0d06d68d7505494a9303e0c"
    sha256 cellar: :any,                 arm64_sonoma:  "538a04d837c73e7dedccfae5c5ff1623cc324f32850d2128ba4b61d0eee50f90"
    sha256 cellar: :any,                 arm64_ventura: "e12fe0ca69129845725c5e4ac10c3c76ef4f5cc2f7f8ee536aac30ea7b9edca2"
    sha256 cellar: :any,                 sonoma:        "b99a499af5e0a5e948f4612945956bb1bbb9c66cd0b7bbe849e47e88eec0f5e4"
    sha256 cellar: :any,                 ventura:       "e8b523b5fb103651183c9ebbb9872e23bc13b676cc4ae23d99a713274429ce68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7c733110473e26cfd6ad050b2c2dbc0b8306126a19c93ce3853996578902755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65ef4c214e35c05c4d2dcb848c7b87bb72b262b0191a45fd7e6b05aa19f6019"
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
