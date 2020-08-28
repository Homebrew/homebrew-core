class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.12.0.tar.gz"
  sha256 "1fc8342c0f0568d2cb3b3b641bcc70893c4088166bd48145432bf6a045a15105"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/yahoojapan/NGT/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "65cfc323a6f03bea0bc24a8cc1265e4320181a2786838f533103887424f2db42" => :catalina
    sha256 "276ff815ce319420fe6126205d2558ee9ff1b534121588475e8b20ba8e933a10" => :mojave
    sha256 "6d14d20024b9edf98e551b3e97d593df05c46daa4206efffaeac6c7f3648cded" => :high_sierra
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
