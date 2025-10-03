class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30033/cdi-2.5.3.tar.gz"
  sha256 "1ebf6098b195c0bb13614015b62a63efd2ef3d4ee94f4c69cadcf236854b2303"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80dceb1f3e1acebdf751f86d7433164bff63a0f88deba2a916b5d70642c87267"
    sha256 cellar: :any,                 arm64_sequoia: "cfc00e9f19ee18c4fd3db9f33e71a3312d28857a8a5911756d17bb36cf3047db"
    sha256 cellar: :any,                 arm64_sonoma:  "be8fbcfc9050ffe9e353d9b0fc31df5fea966babd9625fe014a82724c46f26ab"
    sha256 cellar: :any,                 arm64_ventura: "95ecbbe3065c0a09587de975457e992a2c881844acb54303c4de76e62da81ce4"
    sha256 cellar: :any,                 sonoma:        "c39d215b041512c361686a609de5d5af7994a791bb0d9b163408f29e4dd3a352"
    sha256 cellar: :any,                 ventura:       "1441d2209aa2d2d8f7a373fe47e6eda539fdeb0ba9b4899c911baefe9770ae06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e5351f6875be7fe43b7dd1075999ea63de9c4728c7bb70acf55d50bf27e61af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac2b729c7c93b160f854c4b4d0966f0926b7a32c5685780f24aa080a526146cb"
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
