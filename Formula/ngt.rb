class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.0.tar.gz"
  sha256 "b9eb711cd8a0608f971e1ff2869508730cb2757fd3f9013e028283ac5742bc73"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "eeaeaf23e4b3c9680af6b509936ac8df44299cff92bed77fbc37967cae0f198d" => :big_sur
    sha256 "9200a72e8f12c6019402d11a269ef8e46784c396b6a3f8bd8e7e4bb8a30d9a69" => :catalina
    sha256 "5c83844458ab7b28e4a3e384e1559ccf0a192a5be6a8994cc867189399858703" => :mojave
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
