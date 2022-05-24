class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.bz2"
  sha256 "8681f175d4bdb26c52222665793eef08490d7758529330f98d3b29dd0735bccc"
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

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8962db038baeee22886c3fccf32a73dbc117bf0098e1d576e3265e5b6d3b0545"
    sha256 cellar: :any,                 arm64_big_sur:  "31006195d59197469fef527827c8e0dfe75118c01b1c67d268c51052c060ac6a"
    sha256 cellar: :any,                 monterey:       "d49eb4eb19d29f26499db581585e9bd3a291dbf5804cf4295f3ef5a5beb33979"
    sha256 cellar: :any,                 big_sur:        "16e54dc0a542bb5ef74e0b7ec6429b59cba202230e37456a623163d9c188cae3"
    sha256 cellar: :any,                 catalina:       "6793e4c55780b05aaa766a094d1a5ac1d75cb9f4c790724552d454a44b973260"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5eb8064aa8d4e70e5a36120c0c8959871ace04e478529ec40260b1e69e0767e"
  end

  depends_on "icu4c"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # Fix some library installations being skipped in some cases.
  # Remove with the next release.
  patch do
    url "https://www.boost.org/patches/1_78_0/0001-b2-fix-install.patch"
    sha256 "71e5b96e72e534670043e0fa7743fd34671715e21c3ddb41908a3da284a8920a"
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end
