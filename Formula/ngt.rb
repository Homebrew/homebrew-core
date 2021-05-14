class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.5.tar.gz"
  sha256 "73adada23380317f0cad8cc11325036232551eefa228e1816f62f527bd599665"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "f9fa04239cd45522a09919ed72b324e22764b628361a4556f9821dfc7905c5b1"
    sha256 big_sur:       "0b23f634f6941c50ab7ac380741f3cd51bf54e5acb07e57df9f069f52a41be48"
    sha256 catalina:      "9452b611720c839577ac780a433ba49807e04687de783b2d9969cb6cf51e7610"
    sha256 mojave:        "67e1e8a3a0aaa7c08f79f26c706abc03b489030ad710e9b96099f31632374f03"
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
