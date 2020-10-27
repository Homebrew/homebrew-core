class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.1.0.tar.gz"
  sha256 "77a912ed3c86f8bde31b7d476321d0c2d810570c04a60fa95c4bd32a1955b5cf"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "072822b5f36b1c6ada8cfc05a8db3206fe8cfe2ab34ca97dd8c0c93ab30a30d1" => :catalina
    sha256 "b0b8f49c6114141cd35afd1ce6b992e5e2e0acd83a5e426da9c209a76ff0c165" => :mojave
    sha256 "d878fc06839eb4aa0beaa00ee556b2e9793485381c3fca511cad0397020bce1b" => :high_sierra
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
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-lhelib", "-lntl", "test.cpp", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
