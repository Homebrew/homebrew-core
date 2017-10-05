class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.49.tar.gz"
  sha256 "aec0ab52b6b9c9445d9d0a77e3af52257e21d6e74e94d8c2cb8fa6f11815ee2b"

  bottle do
    cellar :any
    sha256 "c35847e689804879bf9a6cd0177ecf69af577759e003cc42991a9ae3e9104641" => :high_sierra
    sha256 "f330164f390a5a55cb8b14e8e5ec3d140c0a5563d3365608e7068dd09542cb2d" => :sierra
    sha256 "bd02a5b4a1ed096d7ae1ae7df893fa8e17fecdf537173aeb34682a014309cad8" => :el_capitan
    sha256 "a5fc291555d18dcd2c80a6ea3f7ff77337b8c60cc016c07c2cda52599bf1c963" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
