class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.1.0.tar.gz"
  sha256 "641af0f602cfc7f5f5b1cfde0652252def2dfaf5f7962c2595cf598663637951"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "aa33ed89e0e48fde7617d85aa108a11ba5ba80d1d16e9bb592d2c5bf4e47580f"
    sha256 cellar: :any, big_sur:       "7f3e7e0ef958621aea18834b0305c5ee448bfa8f4c916a4ea5357e4641430dac"
    sha256 cellar: :any, catalina:      "e23f0d0f4d351e8bddb8af5c439759a1111b1b5a0f61624eefbe37d13671ac54"
    sha256 cellar: :any, mojave:        "b836a2a23a248b8914d0a6131eaab1844436922dbc741dfe1207fd5e669f89d5"
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
