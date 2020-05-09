class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.11.4.tar.gz"
  sha256 "3b54ab93ecb8345184dee9d94e3aa5ecc005f934d25ac724a709314ff643467b"

  bottle do
    cellar :any
    sha256 "2b379f9d965c216978fb3afce5218e4f33d2e8adc4d7a93751eaad9441f225e1" => :catalina
    sha256 "afe91fbd2b7f3568b76bb8aebc0f58ca4508a36e913f26ff3ee8acc9a3c7e727" => :mojave
    sha256 "efd5d3990a06f2b2cd03b24faa02771ca276fd148b1063c478ee152fc305dfad" => :high_sierra
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
