class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.92.0/boost-1.92.0-b2-nodocs.tar.xz"
  sha256 "ea7b982002cc9dfbe59b0b217b206f470dc75f3de0bb2973d844118934d82411"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256               arm64_tahoe:   "208ac9d44a3220926166fed43f27d407cb0023a6b4f1159e5d895cb6adf825f8"
    sha256               arm64_sequoia: "f1008f6aaf5637dfc69aff90d7844832b0bb9002eee6dfddfeb3eff0452985f9"
    sha256               arm64_sonoma:  "8a416b4c548e567b59c5cb4edcb3abf59fda39b87918493ea6fb4ef57de726f1"
    sha256               sonoma:        "f94cae364c7af23d40b95a5ee9caf252fe2e6c2d9c2fb8278115d7686f6abe5b"
    sha256 cellar: :any, arm64_linux:   "49afd023cb9d1d579cda5bfc3584b3902e94e13c6bfe081d47f31dc231b236f3"
    sha256 cellar: :any, x86_64_linux:  "b9f501a5513bbc63411482fedaaa57a0814967545ec588391e4e27dd3b987c13"
  end

  # Test with cmake to avoid issues like:
  # https://github.com/Homebrew/homebrew-core/issues/67285
  depends_on "cmake" => :test
  depends_on "boost"
  depends_on "open-mpi"

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Keep cxxflags aligned with `boost`
    args << "cxxflags=-std=c++17"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "linkflags=-Wl,-dead_strip_dylibs" if OS.mac?

    (buildpath/"user-config.jam").write <<~JAM
      using #{OS.mac? ? "darwin" : "gcc"} : : #{ENV.cxx} ;
      using mpi ;
    JAM

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=mpi"

    system "./b2",
           "--prefix=install-mpi",
           "--libdir=install-mpi/lib",
           *args

    lib.install Dir["install-mpi/lib/*mpi*"]
    (lib/"cmake").install Dir["install-mpi/lib/cmake/*mpi*"]

    if OS.mac?
      # libboost_mpi links to libboost_serialization, which comes from the main boost formula
      MachO::Tools.change_install_name("#{lib}/libboost_mpi.dylib",
                                       "libboost_serialization.dylib",
                                       "#{formula_opt_lib("boost")}/libboost_serialization.dylib")
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
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
    CPP

    boost = Formula["boost"]
    args = ["-L#{lib}",
            "-L#{boost.lib}",
            "-lboost_mpi",
            "-lboost_serialization",
            "-std=c++17"]

    if OS.linux?
      args << "-Wl,-rpath,#{lib}"
      args << "-Wl,-rpath,#{boost.lib}"
    end

    system "mpic++", "test.cpp", *args, "-o", "test"
    system "mpirun", "-np", "2", "./test"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      find_package(Boost COMPONENTS mpi REQUIRED)
    CMAKE
    system "cmake", ".", "-Wno-dev"
  end
end
