class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.3.tar.gz"
  sha256 "46adb4be6a3f718f6e33dababa16450ef44f6713be5362b0e2218373050755b0"
  license "MIT"

  bottle do
    cellar :any
    sha256 "8edd8ebca89f6c4c01460341d122a842bdf698276e766de47888163703b31450" => :catalina
    sha256 "6702e41433031e30ee9a585f49ff31af21a613f3a6cae449b71fc346fa9c84c8" => :mojave
    sha256 "e151c6702d0428672d70a29388bc2ff56746eebd4e14661eb9bc09a8e36c4720" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "haskell-stack" => :build
  depends_on "boost"
  depends_on "rapidjson"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DBOND_ENABLE_GRPC=FALSE", "-DBOND_FIND_RAPIDJSON=TRUE"
      system "make"
      system "make", "install"
    end
    chmod 0755, bin/"gbc"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/cpp/core/serialization/.", testpath
    system bin/"gbc", "c++", "serialization.bond"
    system ENV.cxx, "-std=c++11", "serialization_types.cpp", "serialization.cpp",
                    "-o", "test", "-L#{lib}/bond", "-lbond", "-lbond_apply"
    system "./test"
  end
end
