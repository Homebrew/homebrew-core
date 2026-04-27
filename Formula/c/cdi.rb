class Cdi < Formula
  desc "C and Fortran Interface to access Climate and NWP model Data"
  homepage "https://code.mpimet.mpg.de/projects/cdi"
  url "https://code.mpimet.mpg.de/attachments/download/30199/cdi-2.6.1.tar.gz"
  sha256 "145c0f987fd07db302159e839178187c813ea161e98f9b3360ab59cb72cdb99f"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdi/files"
    regex(/href=.*?cdi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aeb403836b34a222b394eb47145d981a04396fbd59a009139c27f025910a0eeb"
    sha256 cellar: :any,                 arm64_sequoia: "09c5780f77cc82cddba29479344fe153f4fa85c0b02339c76d910b0c5634e88a"
    sha256 cellar: :any,                 arm64_sonoma:  "fb8c6a39dc3ddf0e70e8076e1851d401b5204bbbaf6905cd22066ffa769d70ba"
    sha256 cellar: :any,                 sonoma:        "7f39bf685d12e0a9c6e4b2be98957c97e6e562cf02c9e1de2eb8c20a55c8f375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d48e6fee6bba5995489ed33158bf0628019afd6411b49772e0f8599984da23a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40aeee15c0c729d93759e0f9e02bf01e97cf7104dac71d6aafabc9f19f940853"
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
