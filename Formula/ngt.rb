class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.9.1.tar.gz"
  sha256 "6e8f327b2c18429b567501f11c8a72a8cb98e1f5008812308d76e8c022c7f87f"

  bottle do
    cellar :any
    sha256 "e85832187d9849ecc9c125cd42c1f48c2165358a3bf84f5f67ae1b0fce138eb9" => :catalina
    sha256 "f03745c7c144e14c0b0caa95b58cd04214b22b4e4bfd986201160d53b27e2d34" => :mojave
    sha256 "b9c7793735d8a88ef1cfee05353b053b3f48dba0f2d559789e92dc0599fa9752" => :high_sierra
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
