class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v1.0.2.tar.gz"
  sha256 "b907eaa8381af3d001d7fb8383273f4c652415b3320c11d5be2ad8f19757c998"

  bottle do
    cellar :any
    sha256 "e3369a43bbddd17d6892a103bdf341e3723ad1e058460eb89a313d0a280551e2" => :catalina
    sha256 "feefa2b8df022a3de8b7a75c17708b189cefabd2b3d8bc1f9b6b695a428555a7" => :mojave
    sha256 "4660787eee74413087898f90953cfc70c211741db546c4cd39058253b36a2877" => :high_sierra
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
