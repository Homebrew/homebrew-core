class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
  sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"
  head "https://github.com/boostorg/boost.git"

  bottle do
    sha256 "1231c02cf9ece283f044b67f9dfc5a41916c777f7f60a88aa407b8ab64737d1f" => :mojave
    sha256 "d260e77cba427df4b1b296d94f06217cc6a412f98c04f4d82662edbb873fb951" => :high_sierra
    sha256 "0672956e6f0656e610060554c2cc52a4312de6a2dbd44de7e3e4ce3674eb9948" => :sierra
    sha256 "d3f89547cb9b48326d1ad72c699694b7f59453887425ce7aa51683da08080d4a" => :el_capitan
  end

  depends_on "boost"
  depends_on "open-mpi"

  needs :cxx11

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
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
