class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.82.0/boost-1.82.0.tar.xz"
  sha256 "fd60da30be908eff945735ac7d4d9addc7f7725b1ff6fcdcaede5262d511d21e"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256                               arm64_sonoma:   "686174ea61507850994d4ac5fc4f492801ea98e4a661dc0c1334de4c663c91cf"
    sha256                               arm64_ventura:  "2fadb6b3e273c30ceef188f465175432be8ffa097227f4e7f220e578badd23c6"
    sha256                               arm64_monterey: "a91ccbcc149a0e9a63b1e35a19430fe270f97ab2f188c7546e1383fd168bbf95"
    sha256                               arm64_big_sur:  "2bb95f88ca16455df8605835cffbf190e0d341a3f90ceca2b7868da58b326b1e"
    sha256                               sonoma:         "62615de5444178bf651d820adeceb6b588b148666585a95c3a372e90affb5e20"
    sha256                               ventura:        "8943122b533bfc1b9eac87018626bf6721282618d935c974c8e7950efdd63c05"
    sha256                               monterey:       "be43b7b2025bf01376b34c220d7cecae67d4bc69decb7a1afd498e551ca38b99"
    sha256                               big_sur:        "50304ea86b434e855dbf014b9cf1ac55a932a21da911d735ba9d71be9108f62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b46177052f005c857caa1430c501f668c585d93242fce1a31d8602fed7617ec9"
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
