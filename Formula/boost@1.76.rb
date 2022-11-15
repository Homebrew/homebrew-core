class BoostAT176 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.bz2"
  sha256 "f0397ba6e982c4450f27bf32a2a83292aba035b827a5623a14636ea583318c41"
  license "BSL-1.0"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "75e4cf932fd41e7be65c1dccd1b776e3d9ad1bff7db7ca0a51ce062c9c5d0380"
    sha256 cellar: :any,                 arm64_monterey: "06b0d013ef4760a75511d8d637377caac0f8643cfc95ac1dfd67a96b708ad8e4"
    sha256 cellar: :any,                 arm64_big_sur:  "b3d192a5702c5ba060ee45e6db0af475cefc61cb32cc4845d4a28769fb750ac8"
    sha256 cellar: :any,                 ventura:        "d6dd0f9418b0052c656cce039065db464db3047c4ef161d73184d6158cc5666e"
    sha256 cellar: :any,                 monterey:       "7e6f3919e4cb4f84c5e756d3040c6892f075c28a9054581188281c2babda255c"
    sha256 cellar: :any,                 big_sur:        "1e8cbd437f466d6784e450c2a382946e2643c6430d290440914074190f75ab25"
    sha256 cellar: :any,                 catalina:       "b9f891df6d3169ce4f36e0f14ab9f9c64ce23f7e488148f6b09f4a3a896a77bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d966b3324e961e814af5bfaaab086051ed51c5a01e2ad916e9e2c2de4b49d397"
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
