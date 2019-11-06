class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.8.1.tar.gz"
  sha256 "62b0c8a0edb6a22c8ca273b8861ce12b9529376b7e48fda94e03d017f3112f59"

  bottle do
    cellar :any
    sha256 "65286d15b504c23db85dd7b63772998b6ca52e6d5ae8757523d19c041afa6af6" => :catalina
    sha256 "1f778e11d6f18989c0032fbcfe5532a0f8c334055d50c84ef600254636b369cd" => :mojave
    sha256 "0f24a5257802ea41d1ff84e05dce685bba01f4a94a1ed9a7747b61ffa09ad310" => :high_sierra
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
