class BoostAT185 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-b2-nodocs.tar.xz"
  sha256 "09f0628bded81d20b0145b30925d7d7492fd99583671586525d5d66d4c28266a"
  license "BSL-1.0"
  revision 3

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "8ebc8c02aee17d821fb71e08dc2df9cece6f9c27920a08afb77e987949cd6a9f"
    sha256                               arm64_sequoia: "86f1d77d5e7aaf72aea541bfe5b3846ecd7ecba66c810eba4282a96ec5365598"
    sha256                               arm64_sonoma:  "fe46b68ddc038313a967ed74ea32daf49dc247bc42cf552ff89f7f62bb444510"
    sha256 cellar: :any,                 sonoma:        "770617eb0d409303c0b96cb73abfcfb1af7ab6397ef3f0d69f6d031e51d48c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bb9de4627dfb79f061a64bee88fbd9123ea114caa362ee91b6c1ef94af57fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3733808e2e612773e6c06b8fd75777c98f1c3acbd831de85c600e64a1582a30"
  end

  keg_only :versioned_formula

  deprecate! date: "2025-04-05", because: :versioned_formula
  disable! date: "2026-04-05", because: :versioned_formula

  depends_on "icu4c@78"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
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
