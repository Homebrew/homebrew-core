class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.0.tar.gz"
  sha256 "2fb1fadb98a791925d529013a65d7e6eefd8accd5fd8953bd45278459b83d875"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "212df077b3196784a257df04f802dae393a42bac5b04a72695b5558b0950eeed"
    sha256 cellar: :any,                 big_sur:       "5c65196fe910a2d2fdcc1270597fcc5dd5d48e70820e69929483bcbae6a9c376"
    sha256 cellar: :any,                 catalina:      "c5f167323605ce1bb7391d5e99cb305ab2bdb42e4b560dfe29646d10795e6c6d"
    sha256 cellar: :any,                 mojave:        "a043964c76a5a2e453342f21a3753ba179e8744d908920c9eb52a85712b851b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd714fc11156a70b20e75bb7641dd1ef934dc0a0869c95fb0aa7b09f949ddbff"
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
