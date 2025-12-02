class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.89.0/boost-1.89.0-b2-nodocs.tar.xz"
  sha256 "875cc413afa6b86922b6df3b2ad23dec4511c8a741753e57c1129e7fa753d700"
  license "BSL-1.0"
  revision 1
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    url "https://www.boost.org/users/download/"
    regex(/href=.*?boost[._-]v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "17d67451900bfa6c77b9acf33509e50fd716118a61bc61060957287db9f63959"
    sha256                               arm64_sequoia: "3619145b1589dca6292290005772953c1f9950121d8d5e97ac99e1b0a9c31e57"
    sha256                               arm64_sonoma:  "2a5716b3b010d3b70a1df34f5e407cec6321e2bcaa653cc6aad684ee1bbfb35c"
    sha256 cellar: :any,                 sonoma:        "d48c415a7fccdc7f526ca90de198b01dad494017fc931b5ecffcd45143abaf75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a60f735d755c1a1836f784ccb34c46bc9c0d26870fba374da532088d9ac13d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b460f7f6465e6d4b3313a52819e8690db5fd01796d8a87f7c867504c9199ac"
  end

  depends_on "icu4c@78"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix for `ncmpcpp`, pr ref: https://github.com/boostorg/range/pull/157
  patch :p3 do
    url "https://github.com/boostorg/range/commit/9ac89e9936b826c13e90611cb9a81a7aa0508d20.patch?full_index=1"
    sha256 "914464ffa1d53b3bf56ee0ff1a78c25799170c99c9a1cda075e6298f730236ad"
    directory "boost"
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
    icu4c = deps.map(&:to_formula).find { |f| f.name.match?(/^icu4c@\d+$/) }
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
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++
    # handling in superenv. Using "cxxflags" and "linkflags" still works.
    # C++17 is due to `icu4c`.
    args << "cxxflags=-std=c++17"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

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
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-L#{lib}", "-lboost_iostreams",
                    "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./test"
  end
end
