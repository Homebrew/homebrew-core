class BoostAT176 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83ac65772152f10da841202acf7bce92ec3993c77a78b632ffed49d1eb2aa8ca"
    sha256 cellar: :any,                 arm64_monterey: "ddd664e4eb4da4ae7adaec20d3309cf1966e58699a291f6944c8895283e809d3"
    sha256 cellar: :any,                 arm64_big_sur:  "fd3fdf87c5f5207d27184e76b8e1e24214bbc0e7f1d5f119553f21e3cf5ad2a9"
    sha256 cellar: :any,                 ventura:        "73c494898266a0b2d02137dda4288c02efbf6d9e24dcf0075c74b59e59393f31"
    sha256 cellar: :any,                 monterey:       "27fe1ac76e73891d48234eeeff722249e3bc49e0cf5a931c538fc488dbc18806"
    sha256 cellar: :any,                 big_sur:        "244c1a3beab51a5f4cc250db278adec77f8382ab358e253c392e334fdca5ddba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28aa69127168176fa9a71de155b8260d71e5bac9dfa8d6c4199a0c6237070728"
  end

  keg_only :versioned_formula

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
