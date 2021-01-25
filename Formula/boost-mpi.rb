class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.75.0/source/boost_1_75_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_75_0.tar.bz2"
  sha256 "953db31e016db7bb207f11432bef7df100516eeb746843fa0486a222e3fd49cb"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    rebuild 1
    sha256 "94e6a5f93cb4c9f225e8efdeee54aec07f8a440d515cb49f4ebbfa836154b09d" => :big_sur
    sha256 "1e3acbc5248b962a5d82eb8edb1e3ffef905cc52106a28d46c46f2b68d24e293" => :arm64_big_sur
    sha256 "4b9073178ad5d46e4770e58bf12323b725dd3053a1afa1d872202120ce1dcd28" => :catalina
    sha256 "c44780bc2bc1ee6c58717f2c4c20f01a00c027f6c035ddeb7ac90e5eaf122dc8" => :mojave
  end

  # Test with cmake to avoid issues like:
  # https://github.com/Homebrew/homebrew-core/issues/67285
  depends_on "cmake" => :test
  depends_on "boost"
  depends_on "open-mpi"

  # Fix build system issues on Apple silicon. This change has aleady
  # been merged upstream, remove this patch once it lands in a release.
  patch do
    url "https://github.com/boostorg/build/commit/456be0b7ecca065fbccf380c2f51e0985e608ba0.patch?full_index=1"
    sha256 "e7a78145452fc145ea5d6e5f61e72df7dcab3a6eebb2cade6b4cfae815687f3a"
    directory "tools/build"
  end

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      install
      threading=multi,single
      link=shared,static
    ]

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n"
    end

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=mpi"

    system "./b2",
           "--prefix=install-mpi",
           "--libdir=install-mpi/lib",
           *args

    lib.install Dir["install-mpi/lib/*mpi*"]
    (lib/"cmake").install Dir["install-mpi/lib/cmake/*mpi*"]

    # libboost_mpi links to libboost_serialization, which comes from the main boost formula
    boost = Formula["boost"]
    MachO::Tools.change_install_name("#{lib}/libboost_mpi-mt.dylib",
                                     "libboost_serialization-mt.dylib",
                                     "#{boost.lib}/libboost_serialization-mt.dylib")
    MachO::Tools.change_install_name("#{lib}/libboost_mpi.dylib",
                                     "libboost_serialization.dylib",
                                     "#{boost.lib}/libboost_serialization.dylib")
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/mpi.hpp>
      #include <iostream>
      #include <boost/serialization/string.hpp>
      namespace mpi = boost::mpi;

      int main(int argc, char* argv[])
      {
        mpi::environment env(argc, argv);
        mpi::communicator world;

        if (world.rank() == 0) {
          world.send(1, 0, std::string("Hello"));
          std::string msg;
          world.recv(1, 1, msg);
          std::cout << msg << "!" << std::endl;
        } else {
          std::string msg;
          world.recv(0, 0, msg);
          std::cout << msg << ", ";
          std::cout.flush();
          world.send(0, 1, std::string("world"));
        }

        return 0;
      }
    EOS
    boost = Formula["boost"]
    system "mpic++", "test.cpp", "-L#{lib}", "-L#{boost.lib}", "-lboost_mpi", "-lboost_serialization", "-o", "test"
    system "mpirun", "-np", "2", "./test"

    (testpath/"CMakeLists.txt").write "find_package(Boost COMPONENTS mpi REQUIRED)"
    system "cmake", ".", "-Wno-dev"
  end
end
