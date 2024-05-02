class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/29313/cdo-2.4.0.tar.gz"
  sha256 "a4790fb8cc07f353b11f9bbe49218b8e4be8e5ae56aade8420bad390510b4d2c"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0efcbb9aa9fde71e19fad9faf1b7bf6c45dccf62cf60530337a9dd640d5b532c"
    sha256 cellar: :any,                 arm64_ventura:  "5fc62c8ef0799cb670c513c3164e963c3767f0221a9ff9f9e6c5393875622ca4"
    sha256 cellar: :any,                 arm64_monterey: "ddecf8b068c2e0152f0a09e3ca695c133b4406611debe87ee74d8c6585332907"
    sha256 cellar: :any,                 sonoma:         "2361db7f81cd6dce7acb3e72ff1e8d03ad001173a763a7e28ce10231bb229227"
    sha256 cellar: :any,                 ventura:        "ee4872d831ed65c7c9442a269f1417e1de540cfcd97e35530b4701e3959ef7a8"
    sha256 cellar: :any,                 monterey:       "62c3b4bfbde205a1ebe31aa135af7b1afdc3137e3fb1e0b8b5a41f411dd29a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f87e7c66dd4b2d0c03e0b45c45d560731608cd5d2537639b3a6457a09cbe9ded"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"
  uses_from_macos "python" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1403
  end

  fails_with :clang do
    build 1403
    cause "Requires C++20 support"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1403

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
    system "#{bin}/cdo", "-f", "nc", "copy", "test.grb", "test.nc"
    assert_predicate testpath/"test.nc", :exist?
  end
end
