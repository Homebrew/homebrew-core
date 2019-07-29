class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.2/poco-1.9.2-all.tar.gz"
  sha256 "6dfffb805741d9fe8ca1d0aa4cbeff571585e6f7ac0bb84ebeff50f40def6b4a"
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
