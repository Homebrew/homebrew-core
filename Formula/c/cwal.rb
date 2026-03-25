class Cwal < Formula
  desc "Blazing-fast pywal-like color palette generator written in C"
  homepage "https://github.com/nitinbhat972/cwal"
  url "https://github.com/nitinbhat972/cwal/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7134c6da51cebc73dbb751f4cf2a112ccecb4940677277e9be28845d85289865"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "imagemagick"
  depends_on "libimagequant"
  depends_on "lua"

  def install
    system "cmake", "-B", "build", "-DCMAKE_BUILD_TYPE=Release", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
      assert_match "v#{version}", shell_output("#{bin}/cwal --version")
  end
end
