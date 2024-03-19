class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/29019/cdo-2.3.0.tar.gz"
  sha256 "10c878227baf718a6917837527d4426c2d0022cfac4457c65155b9c57f091f6b"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9532b61726537587c8287254f8106b594e93a1f98f5508ea865b3ef2bbd9a10b"
    sha256 cellar: :any,                 arm64_ventura:  "a5189ceda83bf399da659c7826970cef4fea37009412ee9e833cf5ca181b67f8"
    sha256 cellar: :any,                 arm64_monterey: "511967f2945f01952c1f2e93a7d5af9b80d0c8eb82f7dfd36ecbfa3c0fb8c250"
    sha256 cellar: :any,                 sonoma:         "0d8d07d9066063fc9fd05bfc6307a1d7250755780fc8d71372b7d623f5e5fdf5"
    sha256 cellar: :any,                 ventura:        "b8f042b2882c80bfde1d58a6abcfe934d67b344e08695880efc878d9ebe67e8b"
    sha256 cellar: :any,                 monterey:       "caf3aaf38e3e101c2ef00da2c414cdb0a16cad3fdff61e378c7b27202e754a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63eeb8df337d0c252a1ea4f992ff7c9d0668294dc22524efc882f12d60fabfc8"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

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
