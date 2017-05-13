class BoostMpi < Formula
  desc "C++ library for C++/MPI interoperability"
  homepage "https://www.boost.org/"
  head "https://github.com/boostorg/boost.git"

  stable do
    url "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2"
    sha256 "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332"

    # Remove for > 1.64.0
    # "Replace boost::serialization::detail::get_data function."
    # Upstream PR from 26 Jan 2017 https://github.com/boostorg/mpi/pull/39
    patch :p2 do
      url "https://github.com/boostorg/mpi/commit/f5bdcc1.patch"
      sha256 "c7af75a83fef90fdb9858bc988d64ca569ae8d940396b9bc60a57d63fca2587b"
    end
  end

  bottle do
    sha256 "db1ffdc724d9d3ecc0bb199896361feef409e7728702765544044cdda3a0d1f2" => :sierra
    sha256 "f4c6deb2f31c5ca9bcff6e2d416c8ca0cfafaa2d3b155c0d29743610e4cfef79" => :el_capitan
    sha256 "a91cea8bddb121b6573165e0d108cd24e501bec97e61c29b0f37c414e87dc62c" => :yosemite
  end

  option :cxx11

  if build.cxx11?
    depends_on "boost" => "c++11"
    depends_on "open-mpi" => "c++11"
  else
    depends_on "boost"
    depends_on :mpi => [:cc, :cxx]
  end

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

    # Build in C++11 mode if boost was built in C++11 mode.
    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    elsif Tab.for_name("boost").cxx11?
      odie "boost was built in C++11 mode so boost-mpi must be built with --c++11."
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
    (testpath/"test.cpp").write <<-EOS.undent
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
