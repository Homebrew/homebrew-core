class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/28882/cdo-2.2.2.tar.gz"
  sha256 "419c77315244019af41a296c05066f474cccbf94debfaae9e2106da51bc7c937"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e175f37dcbf11d0270cb4ab30c769a026dad190a64da36baa062d331e0d52d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ee063b2b16728c7f3aec6822663bd948c12aa04c88eedf72923b69ac28ac646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf27b3f73669012dced5d979f0fa0da10668104b06b1ab51c77b3b4b3098d945"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13c7779e2597e7b4bcc1bef46033df537e3160e6313a317b0383ee88883afe9e"
    sha256 cellar: :any,                 sonoma:         "c93c1e8128dd7bad4e3ec892cc0444277ba221acc5e2cd705bdce9db7f1972a8"
    sha256 cellar: :any_skip_relocation, ventura:        "2b7464bb058d3a5058eed98112470936b31c4dedca6faaaf3a55ba13ec21be46"
    sha256 cellar: :any_skip_relocation, monterey:       "cd875d8ba47f2017144f2efa4a5208ba7b10f8392c3aded5ce573105a13ec13d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b6fc23e090613eb2242c22695d1aaecbba8ba898e44f3c0b29ae2b07de68de4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb42517595a6963b898c777f2a6148acdd72132f8bb7ff0cc3a544cac006250d"
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
