class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.2.tar.gz"
  sha256 "1745d9d1fc5abf804d0d2b37ab722e1ba318dc0f89a6f2f158437d142710c0f4"
  license "MIT"

  bottle do
    cellar :any
    sha256 "5c7c89d4a830486361cc7176fa633f6583f640f2f77c7cba1208278297eca82d" => :catalina
    sha256 "53abaa89e4119a886c857e778a28d316a58e367b82bd84fcb4343bfe4034e18c" => :mojave
    sha256 "b213875a163f78af9d6e50c87cffa2cee5a9a17bf37f7a391dd9ac5ef29c8e5a" => :high_sierra
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
