class BoostAT155 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2"
  sha256 "fff00023dd79486d444c8e29922f4072e1d451fc5a4d2b6075852ead7f2b7b52"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "655c9b514a797113af2e4199457ccb9dd8d8e0364f227390f0ca54b254439f2a" => :mojave
    sha256 "15894f998719ef4130d2dea076accadb709a6d5d0809114452f5175585ccd454" => :high_sierra
    sha256 "16a7e98e578adbf8c353bc868b9cd98e80b41928329743dba1b54ee53d76295c" => :sierra
  end

  keg_only :versioned_formula

  # Patches boost::atomic for LLVM 3.4 as it is used on OS X 10.9 with Xcode 5.1
  # https://github.com/Homebrew/homebrew/issues/27396
  # https://github.com/Homebrew/homebrew/pull/27436
  patch :p2 do
    url "https://github.com/boostorg/atomic/commit/6bb71fdd.diff?full_index=1"
    sha256 "1574ef5c1c3ec28cf3786e40e4a8608f2bbb1c426ef2f14a2515e7a1a9313fab"
  end

  patch :p2 do
    url "https://github.com/boostorg/atomic/commit/e4bde20f.diff?full_index=1"
    sha256 "fa6676d83993c59e3566fff105f7e99c193a54ef7dba5c3b327ebdb5b6dcba37"
  end

  # Patch fixes upstream issue reported here (https://svn.boost.org/trac/boost/ticket/9698).
  # Will be fixed in Boost 1.56 and can be removed once that release is available.
  # See this issue (https://github.com/Homebrew/homebrew/issues/30592) for more details.

  patch :p2 do
    url "https://github.com/boostorg/chrono/commit/143260d.diff?full_index=1"
    sha256 "96ba2f3a028df323e9bdffb400cc7c30c0c67e3d681c8c5a867c40ae0549cb62"
  end

  def install
    # Patch boost::serialization for Clang
    # https://svn.boost.org/trac/boost/raw-attachment/ticket/8757/0005-Boost.S11n-include-missing-algorithm.patch
    inreplace "boost/archive/iterators/transform_width.hpp",
      "#include <boost/iterator/iterator_traits.hpp>",
      "#include <boost/iterator/iterator_traits.hpp>\n#include <algorithm>"

    # Force boost to compile using the appropriate GCC version.
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
    end

    # We specify libdir too because the script is apparently broken
    bargs = %W[--prefix=#{prefix} --libdir=#{lib} --without-icu]

    # Handle libraries that will not be built.
    without_libraries = ["mpi", "python"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bargs << "--without-libraries=#{without_libraries.join(",")}"

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged
      --user-config=user-config.jam
      install
      threading=multi,single
      link=shared,static
    ]

    system "./bootstrap.sh", *bargs
    system "./b2", *args
  end

  def caveats
    s = ""
    # ENV.compiler doesn"t exist in caveats. Check library availability
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
      #include <boost/version.hpp>
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

        assert(strcmp(BOOST_LIB_VERSION, "1_55") == 0);

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}", "-L#{lib}", "-lboost_system", "-o", "test"
    system "./test"
  end
end
