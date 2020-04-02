class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_72_0.tar.bz2"
  sha256 "59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722"
  head "https://github.com/boostorg/boost.git"

  bottle do
    sha256 "85d4a3e20c2b6c3383a6fc6bb2829a08284bd23dfed1ddfe23c95b042ab6a73d" => :catalina
    sha256 "76a3472fb7d69bd52c36f936d932dc70b800108c8ecedf1c11c132ce094af595" => :mojave
    sha256 "9f6879e54a786105e9a2d4cc7275a31f22d4aea0f62417b8eed45e7f82d80449" => :high_sierra
  end

  depends_on "boost"
  depends_on "open-mpi"

  # Fix build on Xcode 11.4
  patch do
    url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
    sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
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
  end
end
