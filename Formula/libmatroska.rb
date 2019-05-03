class Libmatroska < Formula
  desc "Extensible, open standard container format for audio/video"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libmatroska/libmatroska-1.5.0.tar.xz"
  sha256 "f0efdc1827fa8012a16d764a45ed84d544d92a2027113245f522f5e1f713ad1e"
  head "https://github.com/Matroska-Org/libmatroska.git"

  bottle do
    cellar :any
    sha256 "8e522f8965c8f799707c47173ef862cb4d06bcf805141e8d503302aec4a19bf8" => :mojave
    sha256 "b8873f42453f222d6ec1d9244a7a3dd2f9bd22eba07facfd51d07992546e52a2" => :high_sierra
    sha256 "995e5a5155da3a2dfed29e087b3fdf2cad2dae0875d9789b927dd11b15a9e25f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libebml"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end
end
