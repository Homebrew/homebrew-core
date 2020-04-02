class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  revision 1
  head "https://github.com/boostorg/boost.git"

  stable do
    url "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/boost_1_72_0.tar.bz2"
    sha256 "59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722"

    # Fixes significant library search issues in the CMake scripts
    # where it mixes single-threaded and multithreaded libraries.
    # Remove with Boost 1.73.0.
    patch do
      url "https://github.com/boostorg/boost_install/compare/52ab9149544bae82e54f600303f5d6d1dda9a4f5...a1b5a477470ff9dc2e00f30be4ec4285583b33b6.patch?full_index=1"
      sha256 "fb168dd2ddfa20983b565ead86d4355c6d6e3e49bce9c2c6ab7f6e9cd9350bd4"
      directory "tools/boost_install"
    end
  end

  bottle do
    cellar :any
    sha256 "d8e2d025325b306f1efc3edb3c5ccb83313526c00de758ee79f00cdde6901113" => :catalina
    sha256 "e4e69e0a8228fc094f2953cd6bbffc498d55854695689dd849d7db33c87d2c7b" => :mojave
    sha256 "ec7ce92e8316cb6f7d99f391b813f50070dc35b7a641dc259a5d15cf84790a29" => :high_sierra
  end

  depends_on "icu4c"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix build on Xcode 11.4
  patch do
    url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
    sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
    directory "tools/build"
  end

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
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

  def caveats
    s = ""
    # ENV.compiler doesn't exist in caveats. Check library availability
    # instead.
    if Dir["#{lib}/libboost_log*"].empty?
      s += <<~EOS
        Building of Boost.Log is disabled because it requires newer GCC or Clang.
      EOS
    end

    s
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-stdlib=libc++", "-o", "test"
    system "./test"
  end
end
