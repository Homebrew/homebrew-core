class BoostAT176 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5fa1820397b30bc594fc77f937a99af346f8e41340d532a13f59e31c7076f0ea"
    sha256 cellar: :any,                 arm64_sonoma:  "bf2654e857a043032de6fe7fc6c8388a52ee86338dbbfdedc28617bac22f2df4"
    sha256 cellar: :any,                 arm64_ventura: "3966bc23fe94abc372ddb6b2c1d07846ee9c1b2c99793a125c73f36c5f43d0af"
    sha256 cellar: :any,                 sonoma:        "f570c9d3c4e1d1cef19a21761de8b2dc6748445da6dc067457d5e950c023dd1a"
    sha256 cellar: :any,                 ventura:       "5879acd1c2d7f1067f365f9cb705ffd0aeb5dec9a8346ce3ec770e4220ddeb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c27b35876867779cfab02b6db3f56595494935da83e1b8c5a3bd4401c4aeae"
  end

  keg_only :versioned_formula

  disable! date: "2024-12-14", because: :versioned_formula

  depends_on "icu4c@74"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Backport fixes for newer Clang
  patch :p2 do
    url "https://github.com/boostorg/numeric_conversion/commit/50a1eae942effb0a9b90724323ef8f2a67e7984a.patch?full_index=1"
    sha256 "d96761257f7efc2edc8414f1a2522fc07a3d7d56bb55a51d14af9abd39e389c8"
  end
  patch :p2 do
    url "https://github.com/boostorg/mpl/commit/b37b709cbdb6b2c285fb808dab985aa005786351.patch?full_index=1"
    sha256 "b8013ad3e6b63698158319f5efc2fe1558a00c1d2e32193086f741e774acc3e4"
  end

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
    icu4c_prefix = Formula["icu4c@74"].opt_prefix
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "-I#{Formula["boost@1.76"].opt_include}", "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end
