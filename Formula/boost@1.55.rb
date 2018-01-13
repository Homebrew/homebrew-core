class BoostAT155 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/boost/boost/1.55.0/boost_1_55_0.tar.bz2"
    sha256 "fff00023dd79486d444c8e29922f4072e1d451fc5a4d2b6075852ead7f2b7b52"

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
  end

  bottle do
    cellar :any
    sha256 "268a8123cf956c5f8e79115b4a5d5807a9125891ac5df161357f31f917bbe16f" => :high_sierra
    sha256 "bf89ab11c1ceab224a5ece4629987b4d8d137c5c3506a4577301f70b05d0ea97" => :sierra
    sha256 "30bb554952cdbcc445b247f570243c31ab4cafebf55bcfe96b9cabcb5ca2f716" => :el_capitan
    sha256 "f861f79bde1988282064245c5b1080f66f6a4e034162656b627c2bb8de42ebb2" => :yosemite
  end

  keg_only :versioned_formula

  option "with-icu", "Build regexp engine with icu support"
  option "without-single", "Disable building single-threading variant"
  option "without-static", "Disable building static library variant"
  option :cxx11

  depends_on "python" => :optional
  depends_on "python3" => :optional

  if build.with?("python3") && build.with?("python")
    odie "boost@1.55: --with-python3 cannot be specified when using --with-python"
  end

  if build.with? "icu"
    if build.cxx11?
      depends_on "icu4c" => "c++11"
    else
      depends_on "icu4c"
    end
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

      # Link against correct version of Python if python3 build was requested
      if build.with? "python3"
        py3executable = `which python3`.strip
        py3version = `python3 -c "import sys; print(sys.version[:3])"`.strip
        py3prefix = `python3 -c "import sys; print(sys.prefix)"`.strip

        file.write <<~EOS
          using python : #{py3version}
                       : #{py3executable}
                       : #{py3prefix}/include/python#{py3version}m
                       : #{py3prefix}/lib ;
        EOS
      end
    end

    # we specify libdir too because the script is apparently broken
    bargs = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? "icu"
      icu4c_prefix = Formula["icu4c"].opt_prefix
      bargs << "--with-icu=#{icu4c_prefix}"
    else
      bargs << "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc
    without_libraries << "python" if build.without?("python") \
                                      && build.without?("python3")

    bargs << "--without-libraries=#{without_libraries.join(",")}"

    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "install"]

    if build.with? "single"
      args << "threading=multi,single"
    else
      args << "threading=multi"
    end

    if build.with? "static"
      args << "link=shared,static"
    else
      args << "link=shared"
    end

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    end

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
