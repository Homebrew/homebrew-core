class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/30210/cdo-2.6.1.tar.gz"
  sha256 "ccf5f3bd5800f703c031bb5b10ae0cd3feac34d8eba7956661ff1ba6deb5985f"
  license "BSD-3-Clause"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c3a15dbad37674f4d3427145641f30222f7e4c4c324d5b5c5539ca417dc2b78"
    sha256 cellar: :any,                 arm64_sequoia: "12c0a9b67373724ea56b54e5d6cfed58973de6855280d77ad424b8635b0ad08c"
    sha256 cellar: :any,                 arm64_sonoma:  "6d1e82209eaa0f484889e0033738ee842e4f1918ecec6aa784782f5d31b7a5ad"
    sha256 cellar: :any,                 sonoma:        "f9edfe7acc8bd88f159a1c2c3c656205cefe07cac5400811326ce850ae8f06ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25846b88f2415efe4fc6cc22945247e720aa761d7b605f5dae30ec872b1b6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba57f7ace2814e4b2fb744853ac314c4bebe44282f28d98e2f986c4a2e26dac6"
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
    depends_on xcode: ["26.0", :build] if DevelopmentTools.clang_build_version >= 1700
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
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-proj=#{Formula["proj"].opt_prefix}
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
