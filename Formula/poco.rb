class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.9.0/poco-1.9.0-all.tar.gz"
  sha256 "0387bf0f9d313e2311742e1ad0b64e07f2f3e76039eed20e3b9aa9951b88e187"
  revision 1
  head "https://github.com/pocoproject/poco.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "03e7d6932fe64981512af25c1f8b603657293fbaf65b3d6232502a97e96f61f5" => :mojave
    sha256 "95644f8b0931aa8eef1494d099a4cb1e40522c5d35e63a2f090930caa8262828" => :high_sierra
    sha256 "2f0d853a7333f8c727ba9606982c5ff65c6553d6eb52cab090b1ff6b01e6de9d" => :sierra
    sha256 "291e90aa5a585355a5464cf4383d01a79072e25ff6f62e38e96f65da725fcf88" => :el_capitan
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
