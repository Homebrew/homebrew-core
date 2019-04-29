class GlabelsQt < Formula
  desc "Label Designer gLabels v4 in QT"
  homepage "https://github.com/jimevins/glabels-qt/"
  url "https://github.com/jimevins/glabels-qt/archive/continuous.tar.gz"
  version "4.0"
  sha256 "4cbe87e26304aa0ac6454cab573b20c0e07f0acd5945065b96f2f5455b4845e9"
  depends_on "cmake" => :build
  depends_on "qt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/glabels-qt", "--version"
    system "#{bin}/glabels-batch-qt", "--version"
  end
end
