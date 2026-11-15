class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30254/cdo-2.6.6_1.tar.gz"
  version "2.6.6-1"
  sha256 "8a98fe0e0969c4ced89030ab0b755fe9578ce4df3989cc86480fcf9c89a6d91f"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f9077858f95b445f3163e23b01169213079839c8d024a9df70d83635a4006f44"
    sha256 cellar: :any, arm64_tahoe:       "be75aa3d9169245e31e5e20ba457b54b71733d899b4a0936463b7383c0b61b57"
    sha256 cellar: :any, arm64_sequoia:     "a14b629df79549759e6dba33f2e0fa6ae4e13196622da8f7bd193e69fb254be9"
    sha256 cellar: :any, arm64_linux:       "9c97f391b0fccb8f7e2b84510913e26b1f9d2ebc113dab5fe82f644c839fb479"
    sha256 cellar: :any, x86_64_linux:      "132e4ee262f83c4977a565d03c0f4cbcd742d23a815302beeaa5d39e056c28d8"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  on_sequoia do
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700 # for std::jthreads
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1699
    cause "needs C++20 std::jthreads"
  end

  deny_network_access!

  def install
    args = %W[
      --disable-openmp
      --with-eccodes=#{formula_opt_prefix("eccodes")}
      --with-netcdf=#{formula_opt_prefix("netcdf")}
      --with-hdf5=#{formula_opt_prefix("hdf5")}
      --with-proj=#{formula_opt_prefix("proj")}
      --with-szlib=#{formula_opt_prefix("libaec")}
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
