class BoostAT176 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1c89c5b9d19f1d1f7cd3e8453c5ef6a3e0123cb3b14be43a02364d2d80f2f796"
    sha256 cellar: :any,                 arm64_big_sur:  "10a10ba5817a0256d89a2f76abd76963fe8c3c73ec004f2b7067cca6bd3668cd"
    sha256 cellar: :any,                 monterey:       "b3ca5b530ab16616b5d40078f875fce0670ad990d9282877fb6f14580b8380bf"
    sha256 cellar: :any,                 big_sur:        "8f62566feafc51c198bea5e8136c0c91fa84fab0420202f5809b08df8f7d55bc"
    sha256 cellar: :any,                 catalina:       "1b37925c41586e7638575f90e9446eb4c15c35163d7244e80c2a8d54381e4914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887c726d1969e6931f04411c6c6ae7ce16dba04bf0b62d6d5168dbccca41f11f"
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
