class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.4.1.tar.bz2"
  sha256 "fdc89efab1f906128e6c54729967577e8d0462017018bc12551257df5dfe3aa4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "90152a5e1d87cad52d80a79173b5de845623ce3bf4031f1356eb1457123a966e"
    sha256 cellar: :any,                 arm64_sonoma:   "84491aae7c3455ae9708acf082dcc9686ee0d70ba45c995d3f874a15fbca6d01"
    sha256 cellar: :any,                 arm64_ventura:  "0bb7378b952081033a2c964ef36e595029ae377cf753ea6437f54086e07f1bf7"
    sha256 cellar: :any,                 arm64_monterey: "699c836a4e66d518fbcfc3ee3a83a60c526d88909bda1a34667c8e67cded482c"
    sha256 cellar: :any,                 sonoma:         "ca1486d8efa94ae049f2bfb3d8c204551042e44bb866df455689a974152eee2e"
    sha256 cellar: :any,                 ventura:        "01f2602c4c663695f4d7dd5cf6fbe3a9ee6b8485efd11879e0d186fc0def1b61"
    sha256 cellar: :any,                 monterey:       "85490eaa518755542f760200f141b5f65fd71e7796df188f45f16ef4ffabecae"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "eb411330078f95316259af6509eea6c755bc66fd364ab17d8212f4f3801addfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b3244b6baa9d30aa0d625a9c27455437b8bb85a1feb61571dec1d4dd765e81"
  end

  depends_on "pkgconf" => :build
  depends_on "libsndfile"

  on_linux do
    depends_on "e2fsprogs"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libgig/gig.h>
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << gig::libraryName() << endl;
        return 0;
      }
    CPP
    args = %W[
      -L#{lib}/libgig
      -lgig
    ]
    args << "-Wl,-rpath,#{lib}/libgig" unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", *args, "-o", "test"
    assert_match "libgig", shell_output("./test")
  end
end
