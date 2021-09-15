class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.0.tar.gz"
  sha256 "2fb1fadb98a791925d529013a65d7e6eefd8accd5fd8953bd45278459b83d875"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c936a42a04cd8ecaccef61dac38f5d673cd74233146f911bda2d262526b48f95"
    sha256 cellar: :any,                 big_sur:       "a144420ebdab16c29f01c75b5f9feb352c26ef3ebc965c7c0e2ed9a720b57ca8"
    sha256 cellar: :any,                 catalina:      "46dc6b6526ef92092229a6fc705b2b01a98197a3e44fc4b05229fe82ecc5e4e6"
    sha256 cellar: :any,                 mojave:        "46c3e82b0ff78a3ada552097437c7be6e02622f1184f97c7bccaf5636e8ca9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfccf5001726d1fe0c7618095469bd4794f1d910faabadbebeb778c2600868c8"
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "gmp"
  depends_on "ntl"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

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
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-pthread", "-lhelib", "-lntl", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
