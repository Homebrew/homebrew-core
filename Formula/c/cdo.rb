class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30242/cdo-2.6.4.tar.gz"
  sha256 "988d94f80d723506bd061fbdfecdce2412afab37f7b5cf01a379a458a8799234"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "028dfda340b9dc975ca5d14a332086fb98ea33bafaffbce09a772877592ade93"
    sha256 cellar: :any, arm64_tahoe:       "00530ff190de86b4f6e32b3e6a29797947867cf8e1d6b3526bb09abd298ea122"
    sha256 cellar: :any, arm64_sequoia:     "06e524ffe61fc719101d2f8d1fa5598faf23a5fb4b084a26e49cca70b5423eb3"
    sha256 cellar: :any, arm64_linux:       "19326f4488f7dc5132a0df4fd0b86cde33eb9f296c8f2cd3c3bea4784f7549de"
    sha256 cellar: :any, x86_64_linux:      "5bc4c1a94be8dfe1426a777dd7ff37b89cd3a2330a7769fbd3464f0d22450321"
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
