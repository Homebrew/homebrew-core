class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.0.2.tar.gz"
  sha256 "b907eaa8381af3d001d7fb8383273f4c652415b3320c11d5be2ad8f19757c998"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "457cfdab05d0634453d4ddcbf84853f354a7ff7d83a4a5cad8d79edc3e1a3ee5" => :catalina
    sha256 "b74a96fd7b94f1411015de28e8fb1dec5627cb5d8f63f3c7a0fcbd084eae13fe" => :mojave
    sha256 "677d399ee0d241b206d026aea134812570256a6ca6f33ff809d68c2bff26440d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ntl"

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_database_lookup/BGV_database_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "-std=c++14", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-lhelib", "-lntl", "test.cpp", "-o", "build/BGV_database_lookup"

    cp pkgshare/"examples/BGV_database_lookup/runtest.sh", testpath/"runtest.sh"
    system "./runtest.sh"
  end
end
