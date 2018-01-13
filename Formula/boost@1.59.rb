class BoostAT159 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
  sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"

  bottle do
    cellar :any
    sha256 "6566d6a5c983add1b25e56b95ef540ce32b6fff5625aebbda81efbaf1618c9aa" => :high_sierra
    sha256 "8d21c9071cb5229469bef25efd3c598dc8d821c57581f4aa08fdfd265a88a9d9" => :sierra
    sha256 "1e061c511462de8c8ab16004d34691b70c2ef65ea0e4ca85f099b8960cd99421" => :el_capitan
    sha256 "62161b5048eb58ab7df1a3f7adccd51e4ae5f10a82a01af2afd26186231f6936" => :yosemite
  end

  keg_only :versioned_formula

  option "with-icu4c", "Build regexp engine with icu support"
  option "without-single", "Disable building single-threading variant"
  option "without-static", "Disable building static library variant"
  option :cxx11

  if build.cxx11?
    depends_on "icu4c" => [:optional, "c++11"]
  else
    depends_on "icu4c" => :optional
  end

  # Fixed compilation of operator<< into a record ostream, when
  # the operator right hand argument is not directly supported by
  # formatting_ostream. Fixed https://svn.boost.org/trac/boost/ticket/11549
  # from https://github.com/boostorg/log/commit/7da193f.patch
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2ccb6715b3/boost/boost159-questionable-operator.patch"
    sha256 "a49fd7461d9f3b478d2bddac19adca93fe0fabab71ee67e8f140cbd7d42d6870"
  end

  # Fixed missing symbols in libboost_log_setup (on mac/clang)
  # from https://github.com/boostorg/log/commit/870284ed31792708a6139925d00a0aadf46bf09f
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2ccb6715b3/boost/boost159-missing-symbols.patch"
    sha256 "2c3a3bae1691df5f8fce8fbd4e5727d57bd4dd813748b70d7471c855c4f19d1c"
  end

  needs :cxx11 if build.cxx11?

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
    end

    # libdir should be set by --prefix but isn't
    bootstrap_args = ["--prefix=#{prefix}", "--libdir=#{lib}"]

    if build.with? "icu4c"
      icu4c_prefix = Formula["icu4c"].opt_prefix
      bootstrap_args << "--with-icu=#{icu4c_prefix}"
    else
      bootstrap_args << "--without-icu"
    end

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python
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
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}", "-L#{lib}",
                                "-lboost_system", "-o", "test"
    system "./test"
  end
end
