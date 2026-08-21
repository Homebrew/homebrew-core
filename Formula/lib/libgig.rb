class Libgig < Formula
  desc "Library for Gigasampler and DLS (Downloadable Sounds) Level 1/2 files"
  homepage "https://www.linuxsampler.org/libgig/"
  url "https://download.linuxsampler.org/packages/libgig-4.6.0.tar.bz2"
  sha256 "fc331202210919e3172c4d36ab24231dea3667d8722141f0c7939ca545119d01"
  license "GPL-2.0-or-later"

  # Using HTTP rather than HTTPS to avoid SSL connection timeout
  livecheck do
    url "http://download.linuxsampler.org/packages/"
    regex(/href=.*?libgig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f94efc2b8cdb9cf3beb0a8337c7c078296d716b11539370ffe46976c8f535bea"
    sha256 cellar: :any, arm64_sequoia: "f4ab7ec5a877be2262893bb08816621eb377e4f6269383dd5925ba2dcf797e91"
    sha256 cellar: :any, arm64_sonoma:  "94b350a053af0f1be12bc095358d77672b17157dfe42683ade462c43a1c4ecbe"
    sha256 cellar: :any, sonoma:        "cb37547e50b8b19db5092fb27129cb3ed1b4cff400a01b528d1e3f6f86833a1d"
    sha256 cellar: :any, arm64_linux:   "caf93915776096983670a26eb38068b76ca31947376029a5b0aedff6833cd749"
    sha256 cellar: :any, x86_64_linux:  "a4195ffd000dd6d3e1f86df6c1fafe809f8b9e9aeed1cc24c47761e339163608"
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
