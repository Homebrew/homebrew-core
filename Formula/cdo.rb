class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/27481/cdo-2.1.0.tar.gz"
  sha256 "b871346c944b05566ab21893827c74616575deaad0b20eacb472b80b1fa528cc"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "658298956b3aebee777f901467bb9fdddde601688fc139462c494d2be0c15e42"
    sha256 cellar: :any,                 arm64_monterey: "943621910a2b925167e8ccb033f6bb4e0c77ee656e34584174f42b56f32b2b37"
    sha256 cellar: :any,                 arm64_big_sur:  "76c7f5f7e341927c3a3d7c6fc2ee4c17f8c39913da433bb2d55273c1f703150e"
    sha256 cellar: :any,                 ventura:        "4f53994e9b834e81cd3d5fab6d4db0675da8f1d11228ad9f71fc517d558af050"
    sha256 cellar: :any,                 monterey:       "7ee57212a33e25e92eb38bf327c1e1b791a421de44e59f442791c33352cf45ff"
    sha256 cellar: :any,                 big_sur:        "7cd3563b890c8b1e92d1d65d0d2efb4904ab75d29c7b033c91d70770e9c32a12"
    sha256 cellar: :any,                 catalina:       "b335737fe1136b096013d944a33612865142d2d6304955d87f3816a74126173a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f1abbfe0336eda54bf2bee575e5eebf7e297f414baea50f85fba81a958eb54"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["libaec"].opt_prefix}
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
