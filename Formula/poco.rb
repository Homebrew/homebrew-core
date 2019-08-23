class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.3/poco-1.9.3-all.tar.gz"
  sha256 "583c464cb2a85a1b0d1bded22875a929eabca54b1575124b114dc4f7e573aa68"
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "801f6600a2cc20bb56bc3cb5478a662a5f8bbaa2604111577756cc3cfe3084ef" => :mojave
    sha256 "3131a03aebd67fe8c3375bb748b88ecf835c201d5c74eb3b37c8575599316047" => :high_sierra
    sha256 "0b3f369a1358adc74b3249df74bc1f6e8b3a58b4493169dc1c387ceecb1278b2" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
