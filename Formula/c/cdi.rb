class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29309/cdi-2.4.0.tar.gz"
  sha256 "91fca015b04c6841b9eab8b49e7726d35e35b9ec4350922072ec6e9d5eb174ef"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c26a7e5b5908520142602d64d6f6f3cd418d7c074a33bdce4797a46d7ef6e69"
    sha256 cellar: :any,                 arm64_ventura:  "38380367199754d9dda02b4a7ceeabed762b97f5dfced787341e99fbf87d394d"
    sha256 cellar: :any,                 arm64_monterey: "2cec357ca25bc45418fbb8e088ef6dd01eb479c15571cf34026c3d69ef8c2161"
    sha256 cellar: :any,                 sonoma:         "cefbb36095b6131ed994d93c0110671e1e9e32f3b17b5333726b0eb185379b95"
    sha256 cellar: :any,                 ventura:        "3f2a8147426eef4ba20cb40b8e1d866e78eee21c9b016c0fb4515e2372c21c94"
    sha256 cellar: :any,                 monterey:       "980dbd3e42b386ce5380a54be7bc4e97303562d43c28567adc4215f729d64d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fc0b60386f888ccd9d9acb0d628d8f432fe1b0a9732343f023f586dc37e82e1"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    EOF

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end
