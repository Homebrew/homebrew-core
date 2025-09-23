class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.89.0/boost-1.89.0-b2-nodocs.tar.xz"
  sha256 "875cc413afa6b86922b6df3b2ad23dec4511c8a741753e57c1129e7fa753d700"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:   "c6edda64a7d7a6059b344c382396548e0ebdcf137df5d39aed8bf9b51082dd30"
    sha256                               arm64_sequoia: "672ed016041a801f917f6af5b658ce812c06b81cd93eab69c7d0fe21556b0a13"
    sha256                               arm64_sonoma:  "df7e86c4c7dcb10b3da2c910e46d640f07177035885316a699a07e8304e66e6c"
    sha256                               arm64_ventura: "c7a2c303322325c161bf56029e1262d0f94ebe14ee4a8fda4d2fd2c6099a8999"
    sha256                               sonoma:        "80a9bdf93a85c1c321ff4e43cf4cbffee750f8e70dee7a4932d55944ea507fe8"
    sha256                               ventura:       "f350e5f67e5b5b87fa3ca7528d916d796af8f16ddd3b72c8b40f895275d77761"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494f0a3fa0ba367dcea8a923a32039302f4ee96d9c89b31b23c063e7b435188b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "666c9bf5cd91ade6ea3a849b68dd1a47769db902888f6d24930162f364eb4b53"
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

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "linkflags=-Wl,-dead_strip_dylibs" if OS.mac?

    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
      file.write "using mpi ;\n"
    end

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=mpi"

    system "./b2",
           "--prefix=install-mpi",
           "--libdir=install-mpi/lib",
           *args

    lib.install Dir["install-mpi/lib/*mpi*"]
    (lib/"cmake").install Dir["install-mpi/lib/cmake/*mpi*"]

    if OS.mac?
      # libboost_mpi links to libboost_serialization, which comes from the main boost formula
      boost = Formula["boost"]
      MachO::Tools.change_install_name("#{lib}/libboost_mpi.dylib",
                                       "libboost_serialization.dylib",
                                       "#{boost.lib}/libboost_serialization.dylib")
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
            "-std=c++14"]

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
