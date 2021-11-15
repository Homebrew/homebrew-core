class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://downloads.sourceforge.net/project/boost/boost/1.74.0/boost_1_74_0.tar.bz2"
  sha256 "83bfc1507731a0906e387fc28b7ef5417d591429e51e788417fe9ff025e116b1"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  disable! date: "2021-04-08", because: :does_not_build

  depends_on "boost"
  depends_on :macos # Due to Python 2

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    pyver = Language::Python.major_minor_version "python"

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python"

    system "./b2", "--build-dir=build-python",
                   "--stagedir=stage-python",
                   "--libdir=install-python/lib",
                   "--prefix=install-python",
                   "python=#{pyver}",
                   *args

    lib.install Dir["install-python/lib/*.*"]
    lib.install Dir["stage-python/lib/*py*"]
    doc.install Dir["libs/python/doc/*"]
  end

  def caveats
    <<~EOS
      This formula provides Boost.Python for Python 2. Due to a
      collision with boost-python3, the CMake Config files are not
      available. Please use -DBoost_NO_BOOST_CMAKE=ON when building
      with CMake or switch to Python 3.
    EOS
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS

    pyprefix = `python-config --prefix`.chomp
    pyincludes = Utils.popen_read("python-config", "--includes").chomp.split
    pylib = Utils.popen_read("python-config", "--ldflags").chomp.split

    system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_python27",
                    "-o", "hello.so", "-I#{pyprefix}/include/python2.7",
                    *pyincludes, *pylib

    output = <<~EOS
      from __future__ import print_function
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output("python", output, 0)
  end
end
