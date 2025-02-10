class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29833/cdi-2.5.0.tar.gz"
  sha256 "19654af187d8b29e708b1c7e4726143cf26547966dceba8cc5b68690281ddad9"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f798120f10757919038021b9a9e4510d331b614ac678818a636cf7c33c730ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "053f10293e8fb895eb957978e7ac14a8b974c1df4a0b2cb7111e60befda3f2cc"
    sha256 cellar: :any,                 arm64_ventura: "3db0ffc99f12fa23bc860e769b42c06b994b3d51930a1395ca642ab771d34a89"
    sha256 cellar: :any,                 sonoma:        "c1d6beb0092822a5b1d8f179a5c00d7d18af5894fd12bf12a47979d51a817887"
    sha256 cellar: :any,                 ventura:       "8aaf19d666c9153a30716fa898303a1810b4f264e92bca4a2b7506f36e1a8225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "979e1583f8751f47f6a04c3d06dc53a51c041ee7e9c4eec5b019397ae06864bf"
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
