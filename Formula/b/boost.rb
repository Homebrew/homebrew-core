class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  stable do
    url "https://github.com/boostorg/boost/releases/download/boost-1.87.0.beta1/boost-1.87.0.beta1-b2-nodocs.tar.xz"
    sha256 "65b5fff9fb72f1685c9a00c4a125f32613b402482ee361f757482e47d34396ad"

    # Backport Boost.Compute support for latest Boost.Uuid
    patch :p2 do
      url "https://github.com/boostorg/compute/commit/79452d5279831ee59a650c17b71259a821f1a554.patch?full_index=1"
      sha256 "ed4b9740c1f300ed0413498f0cba6f05389b570bec6a4b456d53314a2561d061"
    end
    patch :p2 do
      url "https://github.com/boostorg/compute/commit/54915acaafa003b7aab6f24c74e7fdeaae297ad6.patch?full_index=1"
      sha256 "1d1e83f4cb371003bad84a3789b2fecf215768f4a6f933444eaa4c26905f1e9f"
    end
  end

  livecheck do
    url "https://www.boost.org/users/download/"
    regex(/href=.*?boost[._-]v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9cbf3c05fdd327dd0e0f1a9419e63e10c2351ec7cd51904e054e37d11751a21d"
    sha256 cellar: :any,                 arm64_sonoma:  "9c969ba39918df9f26ac5d283081bd263009747db450095888697c0c83e3a8d2"
    sha256 cellar: :any,                 arm64_ventura: "d49dc78ee528470d8ca0f9762a96d1eba1f80fd4a8d70dea010c7d524cec7133"
    sha256 cellar: :any,                 sonoma:        "14ea0ee012bdb555dcc20fb5b6429ea34bd7aab7b16db606de04074fdf37ddcd"
    sha256 cellar: :any,                 ventura:       "b2ffcb38ea2326444acc8b95c6ccd4fa8d8edbab95270108ecfb85a25b89aeaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a9279f11fcd81f48f47d0b86389cddd27dc077f0ca6948f2ff83f720267119d"
  end

  depends_on "icu4c@76"
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
