class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  license "BSL-1.0"
  revision 1
  head "https://github.com/boostorg/boost.git", branch: "master"

  stable do
    # TODO: Drop single-threaded libraries at version bump.
    #   https://github.com/Homebrew/homebrew-core/pull/182995
    url "https://github.com/boostorg/boost/releases/download/boost-1.86.0/boost-1.86.0-b2-nodocs.tar.xz"
    sha256 "a4d99d032ab74c9c5e76eddcecc4489134282245fffa7e079c5804b92b45f51d"

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
    sha256 cellar: :any,                 arm64_sequoia: "7ed42f5454994b547066d52549a57edd157ca6f80a9f2d73fe69eec4a7bbc5ee"
    sha256 cellar: :any,                 arm64_sonoma:  "70a85cfceb6b54c0ace4956b937aae3cde81a874741f5d9aa5938ffdd7de3d77"
    sha256 cellar: :any,                 arm64_ventura: "da2a9898cde2900e528109b4e0c4db3e26c3f5c7f8d0830c9523c4b3bc9d44a0"
    sha256 cellar: :any,                 sonoma:        "ccd461109e3760cefcc170e8ec75c166e780aba32fa852581e2f88e777bd40aa"
    sha256 cellar: :any,                 ventura:       "6c3b8d51bcbae0c803953304c8c8d9c5743e29df9659b9a28d9fc5f0a6df24e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd0a090c857598cd14490425b8a80351355e23c064d57d7e0a29ca1ea016d9fd"
  end

  depends_on "icu4c@75"
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

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-L#{lib}", "-lboost_iostreams",
                    "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./test"
  end
end
