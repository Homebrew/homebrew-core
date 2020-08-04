class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.2.tar.gz"
  sha256 "1745d9d1fc5abf804d0d2b37ab722e1ba318dc0f89a6f2f158437d142710c0f4"
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
