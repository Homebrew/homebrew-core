class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.2.tar.gz"
  sha256 "70c07d2a2da393c695095fe755836524e3d98efb27a336e206291f71db9cec7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34f163bd12676026f9590a15244bfcb002df6967d031301a822150fa4ca9a888"
    sha256 cellar: :any,                 arm64_monterey: "4f356464d714ffcac9f68b883c70b6d80521e148b4c1522421a28b44ef31c326"
    sha256 cellar: :any,                 arm64_big_sur:  "7c004f3ea1822de6b87312b2ecfe5f1052fc0c73f2981e0ec829d982b1eb9fc1"
    sha256 cellar: :any,                 ventura:        "1e5fc998605dad875c1e1778118107ef0f99d2222464511cc0e2269bf8bf950e"
    sha256 cellar: :any,                 monterey:       "d92cef10a464476085a433a9a796185c8f3acb0c7675b574a9c8e40686f4e97a"
    sha256 cellar: :any,                 big_sur:        "6bacf1a7120bfe69efaf04ba14a3fe2fa0264389bbaace8fa0107d8024525a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dcba1a913111cd6d07c99089fc7766a59cccdca4fd28b860399a1197bb62c82"
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
