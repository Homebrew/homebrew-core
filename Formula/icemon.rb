class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://github.com/icecc/icemon"
  url "https://github.com/icecc/icemon/archive/v3.1.0.tar.gz"
  sha256 "8500501d3f4968d52a1f4663491e26d861e006f843609351ec1172c983ad4464"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/icemon", "--version"
  end
end
