class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/29864/cdo-2.5.1.tar.gz"
  sha256 "418bf91e864cbfe547c3c8e150d31419cfa715e7d345508c5591b1abda5457d1"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd1d32211a82e1cf891757e379a638b80e7eb672fd2a8d2f611372af12c743ff"
    sha256 cellar: :any,                 arm64_sonoma:  "1ff8f37ffcba186f20ec2d6227a929754b11595a77213e141c5f634bf13b5925"
    sha256 cellar: :any,                 arm64_ventura: "4b0080c57a505533e5563817b1fffa4786dc3583bf21176a411173a864e0888e"
    sha256 cellar: :any,                 sonoma:        "4ad6cb5b6a951f679f64b5013969e9f136b7566ca7f0d8e266dc2f2e86be6846"
    sha256 cellar: :any,                 ventura:       "9bf4288a75ee0b7162592c8d0ec79b33217076480734e1de2753fc9d34f35c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5483f4f41ad3427a1f4111517912b39a8f7b29e4da5d1542bdf8937a763d777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b62558687a81c8b989d7885d6128f3b1c3f40fdaf12d6ee966021ef80dbf685"
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
