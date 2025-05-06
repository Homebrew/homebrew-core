class BoostAT185 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-b2-nodocs.tar.xz"
  sha256 "09f0628bded81d20b0145b30925d7d7492fd99583671586525d5d66d4c28266a"
  license "BSL-1.0"
  revision 3

  bottle do
    sha256                               arm64_sequoia: "0d57280eb03360e23f3693d33604711f5912a47c6400fbcf7a78ce4829d35db6"
    sha256                               arm64_sonoma:  "a4d8d3af279e68a17a5d177dfbb716757d59b91448ba82dc8c015bc8749b6e0c"
    sha256                               arm64_ventura: "c60cdfef891f2f447509c8a460db5fd1b16e07111c7169457044eaa46674c9f3"
    sha256 cellar: :any,                 sonoma:        "21d45293e2b2ded9f5ac1c8bfa04867fd0e5d02f15911aa24e73a69665968d69"
    sha256 cellar: :any,                 ventura:       "834cb3ac5b69ae8a4768e2e1773798d7a1ae01aadb761a9e737ff84b8d07a837"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7fd2dc979f3b442f80669bfbb081f05eae3bfa4dd12fa46d21594154104600f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1afa1ddd0506aa3991d3e6b86941fb066fae250feecc9adeaad82780efac55da"
  end

  keg_only :versioned_formula

  deprecate! date: "2025-04-05", because: :versioned_formula

  depends_on "icu4c@77"
  depends_on "xz"
  depends_on "zstd"

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
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c.opt_prefix}
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
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++
    # handling in superenv. Using "cxxflags" and "linkflags" still works.
    # C++17 is due to `icu4c`.
    args << "cxxflags=-std=c++17"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Workaround mentioned in build error:
    # > Define `BOOST_STACKTRACE_LIBCXX_RUNTIME_MAY_CAUSE_MEMORY_LEAK` to
    # > suppress this error if the library would not be used with libc++ runtime
    # > (for example, it would be only used with GCC runtime)
    args << "define=BOOST_STACKTRACE_LIBCXX_RUNTIME_MAY_CAUSE_MEMORY_LEAK" if OS.linux? && Hardware::CPU.arm?

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <boost/algorithm/string.hpp>
      #include <boost/iostreams/device/array.hpp>
      #include <boost/iostreams/device/back_inserter.hpp>
      #include <boost/iostreams/filter/zstd.hpp>
      #include <boost/iostreams/filtering_stream.hpp>
      #include <boost/iostreams/stream.hpp>

      #include <string>
      #include <iostream>
      #include <vector>
      #include <assert.h>

      using namespace boost::algorithm;
      using namespace boost::iostreams;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");

        // Test boost::iostreams::zstd_compressor() linking
        std::vector<char> v;
        back_insert_device<std::vector<char>> snk{v};
        filtering_ostream os;
        os.push(zstd_compressor());
        os.push(snk);
        os << "Boost" << std::flush;
        os.pop();

        array_source src{v.data(), v.size()};
        filtering_istream is;
        is.push(zstd_decompressor());
        is.push(src);
        std::string s;
        is >> s;

        assert(s == "Boost");

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lboost_iostreams", "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./test"
  end
end
