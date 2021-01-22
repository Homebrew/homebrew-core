class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.1.tar.gz"
  sha256 "b63d718e297c6bf0dcabfcf26ab7334fd56386e68adfd1717636d1f68a66122c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "a5d33b8d1f31687d6f8c241472e6af6464568a3fa407fb8191efacab00fee33e" => :big_sur
    sha256 "726916f6ef145e1a541a84526842d0a4cdc922ebd990b102a69346aea2d232a5" => :arm64_big_sur
    sha256 "85514f57252ce423ba7499b56ed88783aaed73ecc9c68f5a76337ae73de91ac5" => :catalina
    sha256 "bbf7d4d86273b6f28c05e8e1f736631b7614d67171d3127b8b746d0b730c94e1" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{lib}"
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
