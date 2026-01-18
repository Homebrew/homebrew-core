class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.5.2.tar.bz2"
  sha256 "ca2be8ce5e0969f90c2df76e03d499f5e27fb5021edbc587de182ff27e8efddd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e08b4cbd024fad1e563040ed574ced16e22ee0b3fb72a084e0375eafe9c7a102"
    sha256 cellar: :any,                 arm64_sequoia: "8615997077dd111493ce6ccf875c28e3d024a0c41670adeb232ac585d7ee82e0"
    sha256 cellar: :any,                 arm64_sonoma:  "ae7d66f193e63a8f4371c8837dd1a85d9ca0dcdc47c63704b99dd7b50bb8c55a"
    sha256 cellar: :any,                 sonoma:        "68ce5928dba5671504d28a8268fc58b8ab5e1dd6cc85e2d65cc46a51f1665cdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7488a743c560200d37a7620fe90c4f480134d944f8c81efb3458feff9e61e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a528fc44ec562e7304d15d3be8728a35c32a209f82985bd99f59cb5b03fbc781"
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
