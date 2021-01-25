class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.0.0.tar.gz"
  sha256 "4e371807fe052ca27dce708ea302495a8dae8d1196e16e86df424fb5b0e40524"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "be618fac7a91399ea6639c6854d79409d03b602c81252d20fd3c58ad8783af60" => :big_sur
    sha256 "9ce026c3f27f43a2a83add1321b376fd5a5f058f3c727487b974e6a52ed4219f" => :arm64_big_sur
    sha256 "f1d09887bf3f3ec3d99d69f3b88bade395061e0663252fc688cee9ed7ec0a583" => :catalina
    sha256 "0bbf1b2dbe1998ae2d9c27b14bc73ab81fc90c2b910320adb3ec416b92603fc0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "ntl"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_country_db_lookup/BGV_country_db_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-lhelib", "-lntl", "test.cpp", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
