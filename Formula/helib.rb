class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.1.0.tar.gz"
  sha256 "641af0f602cfc7f5f5b1cfde0652252def2dfaf5f7962c2595cf598663637951"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f2b559e89169fe6c8f23b56ad688c1724d91e3c90f78d9d438a4d3a426cbd80b"
    sha256 cellar: :any, big_sur:       "7b2ee7e1e1d7039d8beeaa65779600015432bfab192d6800b13aafb87dcc7e36"
    sha256 cellar: :any, catalina:      "407acf9d3b8c3a9fdff58c1fd25ab37db3a415c9858497c6027dfaab750b053f"
    sha256 cellar: :any, mojave:        "d471cba32715cf99e874200faba41d400df7fea5c8943e10466a468a6b97afd3"
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
