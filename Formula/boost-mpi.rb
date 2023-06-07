class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.81.0/source/boost_1_81_0.tar.bz2"
  sha256 "71feeed900fbccca04a3b4f2f84a7c217186f28a940ed8b7ed4725986baf99fa"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256                               arm64_ventura:  "ac780b010068ba52bb103ac2adbd49b408cb02378c24d3f7ca5af627135085f6"
    sha256                               arm64_monterey: "29c78834506d33bc6daf07018a89b2206a41b6837eb806c39269627b276a8cde"
    sha256                               arm64_big_sur:  "1e0aa79477135831cf471875af7156feb6b0f88a8243b1502f4e67c722592d97"
    sha256                               ventura:        "05ee3d29d40ab36e162caab0c41f93e0668bb0cccf8e0bd122a69b386d2db051"
    sha256                               monterey:       "2267f5818e4faf68cddfac386bf10a7d5e64f27c4945e045da909033fc681626"
    sha256                               big_sur:        "2a7addd646eab90da685d7115eecd927f7696da18f9f840b3bada9931c8e95de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5baf414b08d992a092ac2d6cf966d992a3ad8a45b669c116573ebc70c002e4"
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
