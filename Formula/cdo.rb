class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/27276/cdo-2.0.6.tar.gz"
  sha256 "ef120dea9032b1be80a4cfa201958c3b910107205beb6674195675f1ee8ed402"
  license "GPL-2.0-only"

  livecheck do
    url "https://code.mpimet.mpg.de/projects/cdo/files"
    regex(/href=.*?cdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6c11f929a985ebdcaf6784a061fb63bca1d51da6584a8444236ae19a5c88056a"
    sha256 cellar: :any,                 arm64_big_sur:  "c8f4e9d3bcbafe305c4b26a4859895c2b944625bbe454c2474fd06c122cd690e"
    sha256 cellar: :any,                 monterey:       "49e5f9e179f30c24d212231a3ff506f6b99ddcd32de7ced3ec3b4f8d3870a047"
    sha256 cellar: :any,                 big_sur:        "d242226255a6e3f4513b7abeba8c8f7812122c177f843106c4a4013b4e372d68"
    sha256 cellar: :any,                 catalina:       "0140e4e7f0f6e5658741f038bcb97eb5c48b49808feb5533a5435eaf05c53dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26da8bc6926fd6391804db2e08de8af887453d9cb6ff3506333a397382968436"
  end

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "libaec"
  depends_on "netcdf"
  depends_on "proj"

  # Fix build error from missing include. Remove in the next release.
  # Ref: https://code.mpimet.mpg.de/boards/2/topics/13186?r=13240#message-13240
  patch :DATA

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

__END__
diff --git a/src/cdo_fft.cc b/src/cdo_fft.cc
index 887a3d3..86ac107 100644
--- a/src/cdo_fft.cc
+++ b/src/cdo_fft.cc
@@ -1,5 +1,6 @@
 // This source code is copied from PINGO version 1.5
 
+#include <algorithm>
 #include <cmath>
 
 namespace cdo
