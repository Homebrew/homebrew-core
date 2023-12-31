class BoostAT176 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "eeafff189152118243504a54beb22ab68bddd258d6f307ef8c44158cc66757a7"
    sha256 cellar: :any,                 arm64_ventura:  "960bbd424890c9d6a08104dd5714d620d215f144ad69e816154723423989040d"
    sha256 cellar: :any,                 arm64_monterey: "26aa21aaa3142a4fed4e6432664eb50704d06a05e49fda44904a6be8401b67c9"
    sha256 cellar: :any,                 arm64_big_sur:  "30cee145b99d61188734587a08e1bf21b669cf75dfcf4fa1032e76f23b6de51b"
    sha256 cellar: :any,                 sonoma:         "bf4e91f0c9c34fdd260a16a3b885d7dc85917c9908ce50f1243b54685552681d"
    sha256 cellar: :any,                 ventura:        "ae7b3d8a883abed1ea4f7bdd51dd26dd52c7c6dfb126ef819bcace472389b9a7"
    sha256 cellar: :any,                 monterey:       "7458b977ef6a75dc3b873fac286cb3ba2330d06034228fc0ef76c86feaaa0f42"
    sha256 cellar: :any,                 big_sur:        "0552835e6fa8401714d0571c2fb621416da9d78f21f3093d0b0e5a65f2da6812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f070d8d009e7b1c5380fb26ac8e1fec40dd805a90e6153193a75f5c84d6b867"
  end

  keg_only :versioned_formula

  deprecate! date: "2023-12-14", because: :versioned_formula

  depends_on "icu4c"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c_prefix}
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      -sNO_LZMA=1
      -sNO_ZSTD=1
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <string>
      #include <vector>
      #include <assert.h>
      using namespace boost::algorithm;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{Formula["boost@1.76"].opt_include}", "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end
