class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/28013/cdo-2.2.0.tar.gz"
  sha256 "679c8d105706caffcba0960ec5ddc4a1332c1b40c52f82c3937356999d8fadf2"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0de35cbbd9cc30a737e632c3b1df1a62e7257e76e917398f2234a7e25be33353"
    sha256 cellar: :any,                 arm64_monterey: "d4ac2ec9d27889ab2db20703c57dbe5bc28fe27aa2f6874035bb799517480121"
    sha256 cellar: :any,                 arm64_big_sur:  "e6607d07b1744a80aaa8baa5721bb45109e5d1b1aa3248530ef80fcaff3ca7f3"
    sha256 cellar: :any,                 ventura:        "2b449e47b61cc9979306e124ec4e53b02e951f5af52e0cf1240b2deb13d4250f"
    sha256 cellar: :any,                 monterey:       "8a9c979c266895c54bb864ea80d3cd02e664ad226af103e32e4050b3fedb90c8"
    sha256 cellar: :any,                 big_sur:        "2cbfe00b843e47e32f92fc7404314e5808a2db86f05799718d09d33fc4c0b462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d649658aebf8f46ec67b47a271294c4937010f684cdc07ac6cffb2c0522f7adc"
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
