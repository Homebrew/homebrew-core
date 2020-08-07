class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.3.tar.gz"
  sha256 "46adb4be6a3f718f6e33dababa16450ef44f6713be5362b0e2218373050755b0"
  license "MIT"

  bottle do
    cellar :any
    sha256 "5535b65ad5e7ba72b0e671e43c915f051603ad58f3f876892ceb655ac610fba2" => :catalina
    sha256 "f0b6dbc5afaf0b4a49dd240cdcafb08254632b1894737d2d2ad6faef8c13054d" => :mojave
    sha256 "6bd7cd9569089318223d6897fb3232aca500988a351aa674bb4e71de87b0b662" => :high_sierra
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
