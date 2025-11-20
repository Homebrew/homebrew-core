class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.5.1.tar.bz2"
  sha256 "3489349f328eb0d07b3ada8859f9e30d8db8b2a3c833ec7f206542a0bb588f61"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07c8ca43cefd58e905df0c414997935e2c0e5d67fbd0dd13968a429663a30c8e"
    sha256 cellar: :any,                 arm64_sequoia: "ab2280010e70eaf19cb8d3ed2bd789a42b3a8dd10f662e3af077327c2dc546ca"
    sha256 cellar: :any,                 arm64_sonoma:  "1b8c4fa7247bf13d105195e596b7d5609e95137576e0b76621ff6dabbb394e1d"
    sha256 cellar: :any,                 sonoma:        "61d385e3c40e79a0d07a590af95d4e9c9d6801f3291e267f123adbb586cb487d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6c8c33d683dce804963ef2a1d6e68830bab788bd269023f4f893ef205f66782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c7d62b78d9d6f78a1431545e3b7aa77c28c52c45cd580735e2f050158ceda78"
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
