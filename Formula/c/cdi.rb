class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/29658/cdi-2.4.3.tar.gz"
  sha256 "7bf3df83968e15d718857a4823c0bae7d9c16ea17ca95524e1e5b68ab73d2c0d"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40afb9a4266c870e3b8a6cc4eedab7c3911fe3b72ae520c3fff92fabe00b6b66"
    sha256 cellar: :any,                 arm64_sonoma:  "bdf7e3284f561677b004b52473f13894a406ecd49fe60f1e1577aa2623950baf"
    sha256 cellar: :any,                 arm64_ventura: "ec51ac120f66ba071d6f16067730974b41bb5326ec9e21f827d93943a0f4e956"
    sha256 cellar: :any,                 sonoma:        "4652de47f7701dd0ddaae4905bd0e9ce6fed470c92bbc5beb3676c0ec10c4d46"
    sha256 cellar: :any,                 ventura:       "a6523b754420a7653b26e08e8180c24a412b393194ffc1a2a4ff915a97de8d04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7977e0ed395f88c6aa0d80b9a0e8765bf1a147baa70fc6a08244a1271a8c1c7e"
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
