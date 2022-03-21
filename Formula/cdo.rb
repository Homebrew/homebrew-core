class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/26823/cdo-2.0.5.tar.gz"
  sha256 "edeebbf1c3b1a1f0c642dae6bc8c7624e0c54babe461064dc5c7daca4a5b0dce"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c8e44109302f3df59a64b9e4c39ee08e20cc689dc1ed58b1200e34d8f21bfb6f"
    sha256 cellar: :any,                 arm64_big_sur:  "a6e18d68b0493c0c63fea9da676fe1193fd2067c0af9f56b3f505ffe86f4c650"
    sha256 cellar: :any,                 monterey:       "c631f31c13b9e89f8ebb58593d797807e7ba488df3234dbeecd751a248d12d67"
    sha256 cellar: :any,                 big_sur:        "99ec7a933825e61b784c0032452b9bf48f758c0734b5b1700d56dedf6b32d10f"
    sha256 cellar: :any,                 catalina:       "c789280330be3f3a2dbf6fa24289f53513397965c05d26e8938b517a9e58c3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21220a85269fefc5fba4d8e70c3fe814ed3d1edadec508f823bf96beacbcd231"
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
