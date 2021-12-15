class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/26654/cdo-2.0.2.tar.gz"
  sha256 "34dfdd0d4126cfd35fc69e37e60901c8622d13ec5b3fa5f0fe6a1cc866cc5a70"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "255c50b90cf48512d1dc57ffac69c0f6478e27394a1d07ded2bf5b94cb331d2d"
    sha256 cellar: :any,                 arm64_big_sur:  "b8f95793295b483c9d88ebc8ac96020a91bac2d30021fce55b04cd1f2d936d0c"
    sha256 cellar: :any,                 big_sur:        "a7d5559e4f72cf2f1d52ddeaf2a6a8645807370aba14853c2d93ffaeb7d5d096"
    sha256 cellar: :any,                 catalina:       "c7d236a86e58998fec608af10221ff313765187d9a46c48f1e17ddda9fce4652"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f530460448b9fdab84d65ff95c4886ae8a6d974ed0ba9c7789e0a41eec529b"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "szip"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    data = <<~EOF.unpack1("m")
      R1JJQgABvAEAABz/AAD/gAEBAABkAAAAAAEAAAoAAAAAAAAAAAAgAP8AABIACgB+9IBrbIABLrwA4JwTiBOIQAAAAAAAAXQIgAPEFI2rEBm9AACVLSuNtwvRALldqDul2GV1pw1CbXsdub2q9a/17Yi9o11DE0UFWwRjqsvH80wgS82o3UJ9rkitLcPgxJDVaO9No4XV6EWNPeUSSC7txHi7/aglVaO5uKKtwr2slV5DYejEoKOwpdirLXPIGUAWCya7ntil1amLu4PCtafNp5OpPafFqVWmxaQto72sMzGQJeUxcJkbqEWnOKM9pTOlTafdqPCoc6tAq0WqFarTq2i5M1NdRq2AHWzFpFWj1aJtmAOrhaJzox2nwKr4qQWofaggqz2rkHcog2htuI2YmOB9hZDIpxXA3ahdpzOnDarjqj2k0KlIqM2oyJsjjpODmGu1YtU6WHmNZ5uljcbVrduuOK1DrDWjGKM4pQCmfdVFprWbnVd7Vw1QY1s9VnNzvZiLmGucPZwVnM2bm5yFqb2cHdRQqs2hhZrrm1VGeEQgOduhjbWrqAWfzaANnZOdWJ0NnMWeJQA3Nzc3AAAAAA==
    EOF
    File.binwrite("test.grb", data)
    system "#{bin}/cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_predicate testpath/"test.nc", :exist?
  end
end
