class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30127/cdi-2.5.4.tar.gz"
  sha256 "d0256f4ece04ccf0693f77b144a6d6db83296815f6a3742b49ed9c6d185066f3"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aefe60909e3d842998c730e2e7dd44f5622033806c6bca45b4dd8b91df4a6f85"
    sha256 cellar: :any,                 arm64_sequoia: "ca44978c7624176830178303c9155e59a1e5d85b985f6e7670451a33984239df"
    sha256 cellar: :any,                 arm64_sonoma:  "0ba59fd7784215678d7b8a549ac9e155b8499252479fb104efb6fa29102d0702"
    sha256 cellar: :any,                 sonoma:        "078f7264206cb23e77d4d9077088b90e036aa65abec71d8f8b767a69e877dc8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b66da003d94aa389c5e9c0ed691b10fa0e2ffd356dc3feed46843d11f11249ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac635cedf5fee35646d1378910e67d97bb6465c28926a0c907512388d658072b"
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
