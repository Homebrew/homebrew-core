class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29860/cdi-2.5.1.tar.gz"
  sha256 "7e369ed455d153bfbfcb5abd343779dc254b798b0d5ea641cd497a49e39f4de5"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1a2af30986bdf223d03abb0eadea7cd2a925f12edd0c33170b4e533378a3d579"
    sha256 cellar: :any,                 arm64_sonoma:  "16025104184587aedd23423d3b5852d3fe70e0784d7716dbaaa8446d4bb498bd"
    sha256 cellar: :any,                 arm64_ventura: "67bca1e2d7b566358cce8f0d334cf4e7cdd9988ade451eb529916f133c1d55f4"
    sha256 cellar: :any,                 sonoma:        "2479b5cfe6dc105af9800571e330422934c0b532cfea292d33c7fbfef936068d"
    sha256 cellar: :any,                 ventura:       "4239b14c23ec729a89006d68e81e342c81e04d014c487d60fc915b9ff3dd50e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8f0e635a82532348a73894dec184a2081e04ddff27562766ff1f1b30c345398"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cdi.h>
      int main() {
        // Print CDI version
        cdiPrintVersion();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcdi", "-o", "test"
    assert_match "CDI library version : #{version}", shell_output("./test")
  end
end
