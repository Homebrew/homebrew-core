class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2"
  sha256 "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406"
  head "https://github.com/boostorg/boost.git"

  bottle do
    sha256 "11823e8ed799d8a7714d7d619bba5999fe6170535a4e572b83787b25afd7b29c" => :mojave
    sha256 "df0cb6020d06a01c45e5a278cf196de77da020d97e2e84732f8d75940e4eb9a7" => :high_sierra
    sha256 "24d06ffcf80ed94e60176aea55854d7f5bcc5b7cc8e81209ee13321fec32fad8" => :sierra
  end

  depends_on "boost"
  depends_on "open-mpi"

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged-1.66",
            "--user-config=user-config.jam",
            "threading=multi,single",
            "link=shared,static"]

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    open("user-config.jam", "a") do |file|
      file.write "using darwin : : #{ENV.cxx} ;\n"
      file.write "using mpi ;\n"
    end

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=mpi"

    system "./b2", *args

    lib.install Dir["stage/lib/*mpi*"]

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
