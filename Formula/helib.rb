class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.3.0.tar.gz"
  sha256 "f3c7411a4d1cdb935b49df68dbb6a2dcd77f597fb4e3abaae2f15b70db691a19"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "9d54a261f04ae892b5adeb24d9f449725307171456fe66af8304ea8746f7935d" => :big_sur
    sha256 "320e0198e300b850ddfa454f43b975ed66a46fae79c9bbfecd92242ebb56f44f" => :catalina
    sha256 "6d653d18508d62e7dbe141a21ae3bf6ddbb4dbe13be0da7115986a90e7ee1de2" => :mojave
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
