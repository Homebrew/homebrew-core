class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.12.1.tar.gz"
  sha256 "eafc2d11618211017fd51e22bc972dff46cb9ebc4272c80de43ce85111113fd8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "0c0390236b196ef49cd82ab692a1689281db1d06b0632878e534e02126544798" => :big_sur
    sha256 "630a651c1764f527a39d9b43ffe4d6ade5b0004596aad4038d55612f10a21c24" => :catalina
    sha256 "ce88dcbfc71c78b2e3155868a6df503e71771ae488547be9113213f09a35c049" => :mojave
    sha256 "daff8e6efb83eee79a205962f1e2346de46e53f63df7ee4183cfe9dd31f19130" => :high_sierra
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
