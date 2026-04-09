class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30181/cdi-2.6.0.tar.gz"
  sha256 "1040430a305aad6e8d78cecff5137da4466a72b834a65042634368cb9d35af68"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a330b1485d0f2946c11c80ac4d90579c74afc2cfd1fba035f4d6058b13034bb"
    sha256 cellar: :any,                 arm64_sequoia: "81869260131131fcf2816a6288969bbeee4545a0ae67e14fb8cde95d2175da7a"
    sha256 cellar: :any,                 arm64_sonoma:  "1493255fc9b380d748d802165f0689889f376e4103a3f3002cc651ce64a3664f"
    sha256 cellar: :any,                 sonoma:        "8874e946c7f954081da61f2c6c12207c412c8a7229c1c3e6a5cb6e3226fe2ca2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaf2ac68fef9354156f06864a46eff351e7100dcd687bc1fb579a62fab4330f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "237db750a11e5a226e617b6c571ccbe252d9c251a62163eb01fcbe0f8b29a267"
  end

  depends_on "eccodes"
  depends_on "libaec"
  depends_on "netcdf"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
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
