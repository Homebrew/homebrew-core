class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.2.tar.gz"
  sha256 "e22142122173a331392d3425792f64130edd9bc8891f233aea3ae124bef5f52e"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "319379f32e41e57bb1bc2dcc4b33a1b7fdea1ad46f11e74014fa3c312323d5e6" => :big_sur
    sha256 "7d4c8c2068b32859a3c176f46cb153b8211c2c1be8c56d229a4adac1ef16b826" => :arm64_big_sur
    sha256 "12bf96dee60beae5392ab710d3cf059159a75ae088a14b908425a1a375f7c449" => :catalina
    sha256 "3c0de52764c93413bb73bf9da81af843a4aae3ac2c50d4f5788ac8231d6d9c2f" => :mojave
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
