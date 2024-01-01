class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.84.0/boost-1.84.0.tar.xz"
  sha256 "2e64e5d79a738d0fa6fb546c6e5c2bd28f88d268a2a080546f74e5ff98f29d0e"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    url "https://www.boost.org/users/download/"
    regex(/href=.*?boost[._-]v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6b756f347001abeab4d06117f818d6c786c69b43f1169807af626bce7357ccb1"
    sha256 cellar: :any,                 arm64_ventura:  "b0d919557c04b0141596b9936e231eefeb5b80ea0e9cefeb40cbe1937404fb60"
    sha256 cellar: :any,                 arm64_monterey: "a38751ff7e50f5e9b340ea6028f6c7f1ac80e131e261c108394b7f7c53fbd3c1"
    sha256 cellar: :any,                 sonoma:         "16f3b4ef9fc39f10c000061ff2817843cd44d41722c7bf5a8e72c5293d73d771"
    sha256 cellar: :any,                 ventura:        "61da54543473024c5d585d9f5dd8d725db5c08646bd94d2c034d2f505b69345a"
    sha256 cellar: :any,                 monterey:       "b954ded2e6de1c7c2d91f0abf566fdb8ac0352d094f9a0517f1047f227b4152a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17ebadc40acbb098b0401925c791c0e26584c23953cbf164137d9664fdd8df63"
  end

  depends_on "icu4c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # fix for https://github.com/boostorg/process/issues/342
  # should eventually be in boost 1.84
  patch :DATA

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

__END__
diff --git a/libs/process/include/boost/process/detail/posix/handles.hpp b/libs/process/include/boost/process/detail/posix/handles.hpp
index cd9e1ce5..304e77b1 100644
--- a/libs/process/include/boost/process/detail/posix/handles.hpp
+++ b/libs/process/include/boost/process/detail/posix/handles.hpp
@@ -33,7 +33,7 @@ inline std::vector<native_handle_type> get_handles(std::error_code & ec)
     else
         ec.clear();

-    auto my_fd = ::dirfd(dir.get());
+    auto my_fd = dirfd(dir.get());

     struct ::dirent * ent_p;

@@ -117,7 +117,7 @@ struct limit_handles_ : handler_base_ext
             return;
         }

-        auto my_fd = ::dirfd(dir);
+        auto my_fd = dirfd(dir);
         struct ::dirent * ent_p;

         while ((ent_p = readdir(dir)) != nullptr)

