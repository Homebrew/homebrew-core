class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.1.tar.gz"
  sha256 "cbe030c752c915f1ece09681cadfbe4f140f6752414ab000b4cf076b6c3019e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b55ca7c984036c96a712cdf07d87afbbd5b1830613f18d42d96f93793f2b754d"
    sha256 cellar: :any,                 arm64_big_sur:  "86a2b67a36f009f5da7031f426a62516ba43683636a7f124d0592fbd827e048b"
    sha256 cellar: :any,                 monterey:       "dc62e7868fa3d95f4b6fe3bcfc96c99c26f2cd54048bf4614d47bb21c338d9d9"
    sha256 cellar: :any,                 big_sur:        "7ec83df94881c5a6e6219e22c4d2f7676f6ccd6d1def7315d443316a47e92b07"
    sha256 cellar: :any,                 catalina:       "479118627ff0025805e67dbbe8a75a4097a66fc5eb900adb307bb72372b813c6"
    sha256 cellar: :any,                 mojave:         "503957a2db03e7df3255616e8e51b430133ae5e7b91985edddafd18e1317db99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b359482962a9173d78f1ea90090718acd3c40cafc70b17a53a5c41ea72d00a"
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
