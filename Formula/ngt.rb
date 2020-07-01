class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.12.0.tar.gz"
  sha256 "1fc8342c0f0568d2cb3b3b641bcc70893c4088166bd48145432bf6a045a15105"

  bottle do
    cellar :any
    sha256 "20d0b230f7a4ca0c478402e827ffbc1d5c3492818622bfede04b5c60a5daa9f2" => :catalina
    sha256 "4dd35ae5acda58cbe9b840a0f45116eb73a2bebcb0752cafc7439c898c3e6bc2" => :mojave
    sha256 "2a47ea878b03ed9c6bbdfe4007e21b291f2ff3bc6ad7606abe23f1efd5e85d78" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
