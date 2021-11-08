class NceplibsSp < Formula
  desc "NCEP Spectral Transform library"
  homepage "https://github.com/NOAA-EMC/NCEPLIBS-sp"
  url "https://github.com/NOAA-EMC/NCEPLIBS-sp/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "c0d465209e599de3c0193e65671e290e9f422f659f1da928505489a3edeab99f"
  license :public_domain

  depends_on "cmake" => :build
  depends_on "gcc" => :build

  def install
    system "cmake", "-DCMAKE_INSTALL_PREFIX=#{prefix}", "."
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
