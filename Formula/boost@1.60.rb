class BoostAT160 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.bz2"
  sha256 "686affff989ac2488f79a97b9479efb9f2abae035b5ed4d8226de6857933fd3b"

  bottle do
    cellar :any
    sha256 "7a94d461c3b8a3859ad52e87ad82c7fc18f36b53a3a85dea88faa733a5c9f000" => :mojave
    sha256 "50568fe023b32cf9664b023d65d43d7f8e79bfa73415186f63a3faf0b4ae7cc8" => :high_sierra
    sha256 "8ab5b0be67a534c2340b488d27ebc51ccb088c49735949da4c0099359c6ef9f1" => :sierra
    sha256 "f6ef8ae275a8d0c03969eceb248235dbeafd4316d1c97f6a9b79d8aa4ef71027" => :el_capitan
    sha256 "489a6420dc137a356ad300cb10a519073adbf99573515601f6bb87ff5a6622b3" => :yosemite
  end

  keg_only :versioned_formula

  option "with-icu4c", "Build regexp engine with icu support"
  option "without-single", "Disable building single-threading variant"
  option "without-static", "Disable building static library variant"
  option :cxx11

  deprecated_option "with-icu" => "with-icu4c"

  if build.cxx11?
    depends_on "icu4c" => [:optional, "c++11"]
  else
    depends_on "icu4c" => :optional
  end

  # Handle compile failure with boost/graph/adjacency_matrix.hpp
  # https://github.com/Homebrew/homebrew/pull/48262
  # https://svn.boost.org/trac/boost/ticket/11880
  # patch derived from https://github.com/boostorg/graph/commit/1d5f43d
  patch :DATA

  # Fix auto-pointer registration in 1.60
  # https://github.com/boostorg/python/pull/59
  # patch derived from https://github.com/boostorg/python/commit/f2c465f
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9e56b45/boost/boost1_60_0_python_class_metadata.diff"
    sha256 "1a470c3a2738af409f68e3301eaecd8d07f27a8965824baf8aee0adef463b844"
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
    system ENV.cxx, "-I#{include}", "test.cpp", "-std=c++1y", "-L#{lib}",
           "-lboost_system", "-o", "test"
    system "./test"
  end
end

__END__
diff -Nur boost_1_60_0/boost/graph/adjacency_matrix.hpp boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp
--- boost_1_60_0/boost/graph/adjacency_matrix.hpp	2015-10-23 05:50:19.000000000 -0700
+++ boost_1_60_0-patched/boost/graph/adjacency_matrix.hpp	2016-01-19 14:03:29.000000000 -0800
@@ -443,7 +443,7 @@
     // graph type. Instead, use directedS, which also provides the
     // functionality required for a Bidirectional Graph (in_edges,
     // in_degree, etc.).
-    BOOST_STATIC_ASSERT(type_traits::ice_not<(is_same<Directed, bidirectionalS>::value)>::value);
+    BOOST_STATIC_ASSERT(!(is_same<Directed, bidirectionalS>::value));

     typedef typename mpl::if_<is_directed,
                                     bidirectional_tag, undirected_tag>::type
