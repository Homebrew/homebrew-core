class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30225/cdi-2.6.3.tar.gz"
  sha256 "7256a0771cb827b9058701d8460e51549736d630b2d4354cdc652221f0f654e2"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aeb4725741da8c0583292caff67df6ed5609ca1f34b0287a65d5ab2ca73f7781"
    sha256 cellar: :any, arm64_sequoia: "a45f9bd22edf7b9f856ea31dd48fd255d6387a6d868b34f8a05b30ec038ec69d"
    sha256 cellar: :any, arm64_sonoma:  "666b827d57742e5a54ad7d0c9ed52609dcef39f1b3258e5496bf228ffe49570d"
    sha256 cellar: :any, sonoma:        "fe67c713bed4693445fa84f50e95dc5d31d2b0b7656879cce9c4815e176c2867"
    sha256 cellar: :any, arm64_linux:   "404bf01e222d2e5385dbea2096166cd915a95b36c57b2a4cb4d8f7504f79af17"
    sha256 cellar: :any, x86_64_linux:  "2688072e65c1edf8cb25c440e3e2f8cd0654287eeca0b2cbc49a122976d24dc4"
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
      --with-eccodes=#{formula_opt_prefix("eccodes")}
      --with-netcdf=#{formula_opt_prefix("netcdf")}
      --with-szlib=#{formula_opt_prefix("libaec")}
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
