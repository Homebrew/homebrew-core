class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.3.1.tar.gz"
  sha256 "8ef47092f6b15fbb484a21f9184e7d936c360198515b6efb9a55d3dfbc2ea4be"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "004ce4122626f0f6bc5ffc0bf97dd8b8be979ab6025898ec413d270b220e0985" => :big_sur
    sha256 "0d3a2af4c976d6c83a3ce2885006e8c6c1aeba6b841df97241d34b15ed2b1141" => :catalina
    sha256 "0b4c9c77add39afa71a846e56cd59b7ecffe001556d8f8ca7fb3fb17559c9f72" => :mojave
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
