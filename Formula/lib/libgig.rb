class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.4.0.tar.bz2"
  sha256 "b5ef0149157e3869e49c844a08e69191c93b59cfd27c4b8dd413fd32797e4bcb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8852fc0cbdf394d0d6aa81b70a1295032d00a3d807c02738efd24dd438cc01d"
    sha256 cellar: :any,                 arm64_ventura:  "39a6dac35658dd82ebb37d439a025494e9d38a5f578bd843921fb01c17c5e83a"
    sha256 cellar: :any,                 arm64_monterey: "a18ef09113d7cb18446d4490001c63f3998f3eca77ddb52d0fc18ffbe96ed35d"
    sha256 cellar: :any,                 sonoma:         "e2f162237927953c0ab2b4b50ffd8ba0b8a9b9354f4903d2301b5a0e2784da2a"
    sha256 cellar: :any,                 ventura:        "dd7663f819c3d815f53b4b368565f2dd18a93849d15b29aae41ebe599b63892a"
    sha256 cellar: :any,                 monterey:       "84856efdb102ced26fef47ae18945e94694a2b7d042ac14cb8c29af4555f0c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4537ed3bbd107fb171c762a14fe9611196b8a584e7e3409606aa7a56b40fb16"
  end

  depends_on "pkg-config" => :build
  depends_on "libsndfile"

  on_linux do
    depends_on "e2fsprogs"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libgig/gig.h>
      #include <iostream>
      using namespace std;

      int main()
      {
        cout << gig::libraryName() << endl;
        return 0;
      }
    EOS
    args = %W[
      -L#{lib}/libgig
      -lgig
    ]
    args << "-Wl,-rpath,#{lib}/libgig" unless OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", *args, "-o", "test"
    assert_match "libgig", shell_output("./test")
  end
end
