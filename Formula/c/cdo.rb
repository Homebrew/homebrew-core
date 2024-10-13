class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/29649/cdo-2.4.4.tar.gz"
  sha256 "49f50bd18dacd585e9518cfd4f55548f692426edfb3b27ddcd1c653eab53d063"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/news"
    regex(/Version (\d+(?:\.\d+)+) released/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f5060169bd6908bb24eb3646dd108e4152c15ae02ccd97313488ee877cc8696d"
    sha256 cellar: :any,                 arm64_sonoma:  "0dfc6b6bc0014245bde240d0a5d7c937861924a0fb23e1750e2c4734a7798c60"
    sha256 cellar: :any,                 arm64_ventura: "f286a7c3da8e14dd0446e4f927e40c67c521a893ac0dc7cda03c3b659bdc5acb"
    sha256 cellar: :any,                 sonoma:        "c0ab5a2f663b2957dad59d99d8840a9b43680bb6bcf2a31b18704db3fe31955d"
    sha256 cellar: :any,                 ventura:       "dc63bef96d309e7a9e4fc6d6011e789deee8b44eff2bf490e112764fa107cd7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12fb6328178520d1017b1004ac3a0cea544117a57d62e0fd9e45d64f7d1427e"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  on_linux do
    depends_on "util-linux"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    args = %W[
      --disable-openmp
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
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
    assert_predicate testpath/"test.nc", :exist?
  end
end
