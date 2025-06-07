class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.5.0.tar.bz2"
  sha256 "0879d28b9b6392da5985826dbdd8d9c957b2a032a2f10190506aef2e22f3c54a"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f85773d19792519d3d19e73b0275a23b9ef84e68e3e57644615a488e4f324af2"
    sha256 cellar: :any,                 arm64_sonoma:  "e4081ce14559fbd6f48102d7dfc1b513e37cee4afbd7121c74cea1e8d53ffff4"
    sha256 cellar: :any,                 arm64_ventura: "789e678cdb2dff09270c004bbc81d5e431581a647be96e7ba66302329d6c3b8c"
    sha256 cellar: :any,                 sonoma:        "2e9b576c4c145c1472c5c78ef36cf3b56d386e98d2cfd82021349d7d2436b7f4"
    sha256 cellar: :any,                 ventura:       "bf0a74884fdc6883c0684672d528787bb0d2e2472c611af8c2dedc16ef524081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "906de752a65d327ae5c80451724c6a97cae3e313214e08d021b95ed62d77072f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "894ee2397192dc48e2d0cc236fe3fd8bb3e4bb259683f91f8a3fe9fd0517b571"
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
