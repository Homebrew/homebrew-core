class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.3.0.tar.bz2"
  sha256 "a06d09878780c6c19dd8db9c33544d53a93357f9e27b14a983aaaba68fffa794"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f25257d7f210d0d3a2f0cff724db229618be0a8123ccffa358d2823ef77f8241"
    sha256 cellar: :any,                 arm64_big_sur:  "fa41e608f0e97d0854cb808a6841addebcefc1243b231b9fa98052feda51ea67"
    sha256 cellar: :any,                 monterey:       "9f5f9c6755666c7a5fa7f893782c9f438d5c67e3fa6f3d010ed0cbcf8fb0a580"
    sha256 cellar: :any,                 big_sur:        "155c5b2d28ca46b08c4d88ffe669d0d16af29d84f58d81c42036bc6beaf1f093"
    sha256 cellar: :any,                 catalina:       "0b00303d4e051d1099a234022f9ee695838ea6effc232dc830c42304b0d5e699"
    sha256 cellar: :any,                 mojave:         "17999aa905c481e685770fe73604dd5c0ff635fa9410c0a8e5ac1067f1de37c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6e21355854f6b5b7ce78a61253f2b1c4f91f5a67092335bb582d10106ba4ff"
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
