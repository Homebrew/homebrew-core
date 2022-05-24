class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  # Please add to synced_versions_formulae.json once version synced with boost
  url "https://boostorg.jfrog.io/artifactory/main/release/1.78.0/source/boost_1_78_0.tar.bz2"
  sha256 "8681f175d4bdb26c52222665793eef08490d7758529330f98d3b29dd0735bccc"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256                               arm64_monterey: "b0de85ec447e59dfb2916736f591b1d36de0047d925a483681234a7116e4d5c6"
    sha256                               arm64_big_sur:  "fb52afb9037e1740fabc4a1d75de4ce5db82f0651e7052668adafb75de1a73aa"
    sha256                               monterey:       "50cbe0dfbca9e77cfb7936af7f62e02528bcfa5e13580e8edf453b7f0eaff362"
    sha256                               big_sur:        "d9ee7034172764690b5af59878614dcaa65089ad24523dbfe8046ebc9a505acf"
    sha256                               catalina:       "3e74dda3dc390f98e5636e5092f66a4719f6159680fc53b895867498aab59ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19180c1f9be0556eda38d175b21818191f3698b0454811f5a0ef6e7e3d78524e"
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
      MachO::Tools.change_install_name("#{lib}/libboost_mpi-mt.dylib",
                                       "libboost_serialization-mt.dylib",
                                       "#{boost.lib}/libboost_serialization-mt.dylib")
      MachO::Tools.change_install_name("#{lib}/libboost_mpi.dylib",
                                       "libboost_serialization.dylib",
                                       "#{boost.lib}/libboost_serialization.dylib")
    end
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
    args = ["-L#{lib}",
            "-L#{boost.lib}",
            "-lboost_mpi-mt",
            "-lboost_serialization"]

    if OS.linux?
      args << "-Wl,-rpath,#{lib}"
      args << "-Wl,-rpath,#{boost.lib}"
    end

    system "mpic++", "test.cpp", *args, "-o", "test"
    system "mpirun", "-np", "2", "./test"

    (testpath/"CMakeLists.txt").write "find_package(Boost COMPONENTS mpi REQUIRED)"
    system "cmake", ".", "-Wno-dev"
  end
end
