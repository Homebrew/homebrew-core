class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/27654/cdo-2.1.1.tar.gz"
  sha256 "c29d084ccbda931d71198409fb2d14f99930db6e7a3654b3c0243ceb304755d9"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d89b12fc78dff63d66f0bf87310d76216a149116d4cd006698c991a576f04cad"
    sha256 cellar: :any,                 arm64_monterey: "83eac588cd73706edfef31b63cb85e2966f762a4f0a02ca366da2f5edce38851"
    sha256 cellar: :any,                 arm64_big_sur:  "0494b5787eae90ea304241a55cef9228a03af0dc51d2c58a19b9ce0fcc282205"
    sha256 cellar: :any,                 ventura:        "fcd1c9fb8575d852d2e27d0ceb136c3fe376e0ae391ba9d009f3a0b8b501ba13"
    sha256 cellar: :any,                 monterey:       "080c0418533dc364d20b1016fd4787185dc157400a24eb25fe8392ec296765f5"
    sha256 cellar: :any,                 big_sur:        "db7e6646f014c87d67c6b6a6c61c58a951c31aeb4879c13b1833157cc8627bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a527a90f90a6539f701eb1dec2887f85155fd87351316b09a0d5b9bc7665360"
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
