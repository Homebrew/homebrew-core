class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/26761/cdo-2.0.4.tar.gz"
  sha256 "73c0c1e5348632e6e8452ea8e617c35499bc55c845ee2c1d42b912a7e00e5533"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "11265316f9d416cd681a9f26ad4b5039c7f2183cff4fa9dd6042267b28ee6f77"
    sha256 cellar: :any,                 arm64_big_sur:  "e8755e1d69ded41b5412483288549accc560d33d66ad15159da00b18b82a7898"
    sha256 cellar: :any,                 monterey:       "c0dc95130f6e089c0024c48444ca5ba84662df54b84a529aad2b59f0651e9e5f"
    sha256 cellar: :any,                 big_sur:        "130c01eb36be886b4fca7800af26f9df9a6bba820d50d3245f847e6fe597a358"
    sha256 cellar: :any,                 catalina:       "ffce788f133146b31e3ab4b4e4ed0577f5eb8ec562899e983d05bba898a9fe04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c890ffd9329c1e62cc19251190136aafedb7636019ef2d590a8b7c260258ccf3"
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
