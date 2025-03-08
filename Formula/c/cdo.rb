class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/29786/cdo-2.5.0.tar.gz"
  sha256 "e865c05c1b52fd76b80e33421554db81b38b75210820bdc40e8690f4552f68e2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5bfb89e3eef1e110a1d0813d3f1075081517b1a0cb619febc6f4c929662f5a14"
    sha256 cellar: :any,                 arm64_sonoma:  "56c6ecb97d39275362a9ea0765920cbb0f8e16a9664550d532f53c5a3b17cd8e"
    sha256 cellar: :any,                 arm64_ventura: "50135f7afffe6d66409ef2e17ddcc2fa1e3c20a4a81283712b50e95cc7d37ef6"
    sha256 cellar: :any,                 sonoma:        "9dd3ea94e634eeec45eab563f244edb53725ecbacea4f9d798361bee1f3cfd7c"
    sha256 cellar: :any,                 ventura:       "fe11bad09c587b0e8bf7de19580ee9224e394b94e79c34fb8bdb820b22fce63b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3779198c547c91ea220675e3545179e66ffb0000d8950942510dcf280899c2f"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      --disable-openmp
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    data = <<~EOF.unpack1("m")
      R1JJQgABvAEAABz/AAD/gAEBAABkAAAAAAEAAAoAAAAAAAAAAAAgAP8AABIACgB+9IBrbIABLrwA4JwTiBOIQAAAAAAAAXQIgAPEFI2rEBm9AACVLSuNtwvRALldqDul2GV1pw1CbXsdub2q9a/17Yi9o11DE0UFWwRjqsvH80wgS82o3UJ9rkitLcPgxJDVaO9No4XV6EWNPeUSSC7txHi7/aglVaO5uKKtwr2slV5DYejEoKOwpdirLXPIGUAWCya7ntil1amLu4PCtafNp5OpPafFqVWmxaQto72sMzGQJeUxcJkbqEWnOKM9pTOlTafdqPCoc6tAq0WqFarTq2i5M1NdRq2AHWzFpFWj1aJtmAOrhaJzox2nwKr4qQWofaggqz2rkHcog2htuI2YmOB9hZDIpxXA3ahdpzOnDarjqj2k0KlIqM2oyJsjjpODmGu1YtU6WHmNZ5uljcbVrduuOK1DrDWjGKM4pQCmfdVFprWbnVd7Vw1QY1s9VnNzvZiLmGucPZwVnM2bm5yFqb2cHdRQqs2hhZrrm1VGeEQgOduhjbWrqAWfzaANnZOdWJ0NnMWeJQA3Nzc3AAAAAA==
    EOF
    File.binwrite("test.grb", data)
    system bin/"cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_path_exists testpath/"test.nc"
  end
end
