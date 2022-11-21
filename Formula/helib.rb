class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.1.tar.gz"
  sha256 "cbe030c752c915f1ece09681cadfbe4f140f6752414ab000b4cf076b6c3019e4"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "cb50632c3c96fbb78bd1a00011482bc72af2237cd92d7d8cfa0757322ff8bf71"
    sha256 cellar: :any,                 arm64_monterey: "a1bb15e9acfc20963af42f415e063a98c97b38f1893b40c7db5b9468b200509a"
    sha256 cellar: :any,                 arm64_big_sur:  "0cc75cb7e8d863c93ed6a00d7914924b4c88439d8741d56e644ef927422ce7a4"
    sha256 cellar: :any,                 ventura:        "2babae50254625c99f41c09918cf53ffe1caa88ced1c4df497811aa93f453c2f"
    sha256 cellar: :any,                 monterey:       "6f056c82e35c77d4958d117a15e02f3d3b0246d444b47c9620d8933ed40aff5c"
    sha256 cellar: :any,                 big_sur:        "83405e4482e49d720269dd76aa39fe4d97f6b85d5e71db310d21e431ac54cfe5"
    sha256 cellar: :any,                 catalina:       "827101ec9dce3beb4d8dd344ad593f5e46a9d0787c595ab8d75811acd3660aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43bb0c66cbb108055b9f557f2317643f4366fc7cdaf4e7de40ea33ca12ece48d"
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "gmp"
  depends_on "ntl"

  fails_with gcc: "5" # for C++17

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
