class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.5.2.tar.bz2"
  sha256 "ca2be8ce5e0969f90c2df76e03d499f5e27fb5021edbc587de182ff27e8efddd"
  license "GPL-2.0-or-later"

  # Using HTTP rather than HTTPS to avoid SSL connection timeout
  livecheck do
    url "http://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "58e7797503b7e5ef6da0a9c83309c61961fbecb1526d5fdbc6b76c566aef9ac1"
    sha256 cellar: :any,                 arm64_sequoia: "0c746ae796c263224f6422ca2ad475390e9c79ca87c026678a97c7b6a17d43d0"
    sha256 cellar: :any,                 arm64_sonoma:  "8a7acab39a8e2837d375612244d49d49d702780633065f7bee6eb670062f8938"
    sha256 cellar: :any,                 sonoma:        "39a06918cb0cd0bb14f245f8927e00c4e2a0cd94c90024089cfcc54343bf85b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48e26ac9b17ef9b5e60d335f036853dd0cac878b735596ddf79bac241c216011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c4bd1c437f242d035116f3d2f136076d4599de01d8b0bea1309daec3f9ccfe2"
  end

  depends_on "pkgconf" => :build
  depends_on "libsndfile"

  on_linux do
    depends_on "e2fsprogs"
    depends_on "util-linux"
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
