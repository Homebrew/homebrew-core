class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.1.0.tar.gz"
  sha256 "77a912ed3c86f8bde31b7d476321d0c2d810570c04a60fa95c4bd32a1955b5cf"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "457cfdab05d0634453d4ddcbf84853f354a7ff7d83a4a5cad8d79edc3e1a3ee5" => :catalina
    sha256 "b74a96fd7b94f1411015de28e8fb1dec5627cb5d8f63f3c7a0fcbd084eae13fe" => :mojave
    sha256 "677d399ee0d241b206d026aea134812570256a6ca6f33ff809d68c2bff26440d" => :high_sierra
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
