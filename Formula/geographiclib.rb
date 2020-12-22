class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib/GeographicLib-1.51.tar.gz"
  sha256 "34370949617df5105bd6961e0b91581aef758dc455fe8629eb5858516022d310"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "e07ad5fe631f3877b528d10857055e2c8c3d25ba0405dddf6c3522cddd9b2364" => :big_sur
    sha256 "8a525a6c0f80a6081791a40892e64a71f1f9bf819097c78ce4fa94b2f1a4e170" => :catalina
    sha256 "fb92606cfaa6ec7cf519bed8089886679ade7b98be2609c0c46b783a825bac18" => :mojave
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      on_macos do
        args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}"
      end
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
