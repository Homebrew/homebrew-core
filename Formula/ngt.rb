class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.13.4.tar.gz"
  sha256 "f41134fc26cd2bd03c6bc480de8a752f1bc1f93853010e3f8d3dab64408a3c40"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "2904b34765e80cab35c4ba6eced566acebd6ccc785dc0b02cda507d1fce44256"
    sha256 big_sur:       "abb91b335f7adc31fe0406e29f5dee6c485c966fed3f24abaadf2f0f110d6fbe"
    sha256 catalina:      "5bb09741c501f1dfec11e46652022c929de3d79d7a268fa52f90e3d2dbde41a4"
    sha256 mojave:        "b00f6760adccd430822d17e27b8fd3202ff332a5a8bb93734e5e0b8ebcc01958"
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
