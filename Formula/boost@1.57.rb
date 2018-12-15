class BoostAT157 < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.57.0/boost_1_57_0.tar.bz2"
  sha256 "910c8c022a33ccec7f088bd65d4f14b466588dda94ba2124e78b8c57db264967"

  bottle do
    cellar :any
    sha256 "662ca2c70c493d0ad0715f93daedf518dfda501bc55de18bc6f393f2e541c075" => :mojave
    sha256 "a9eab1fbd081d88a4ee1d8102a038784b46ef98d77f11943793f8445341871ae" => :high_sierra
    sha256 "2a5722e316d528b2ee1b290c2bda772c19c426f32c8bcb6609c250d68c59d6cb" => :sierra
    sha256 "1c2b58d63f0d0f24a07cb60653cf1e674b78f4529c5e7b89ea4208d4db8fb494" => :el_capitan
    sha256 "993b2b875755b7a1b0b7bbb97269545705fa3b30df3e4a03868c0e53a1dc7599" => :yosemite
  end

  keg_only :versioned_formula

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
    end

    # libdir should be set by --prefix but isn't
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}"
      --without-icu
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged
      --user-config=user-config.jam
      install
      link=shared,static
      threading=multi,single
    ]

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
