class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2"
  sha256 "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "b377edc8e5bc2ea6b3873d54d694298590278c291eb2820d408691e7491b853a" => :mojave
    sha256 "51810bd5962d2ed44d696fb583de2a9f4b35084ad768d0789490701f748365a4" => :high_sierra
    sha256 "23a5aadabf25a54196083be6478c105efd8c1503fc36330cfd5cafff62b16a80" => :sierra
  end

  depends_on "boost"

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged-1.66",
            "threading=multi,single",
            "link=shared,static"]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    pyver = Language::Python.major_minor_version "python"

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python"

    system "./b2", "--build-dir=build-python", "--stagedir=stage-python",
                   "python=#{pyver}", *args

    lib.install Dir["stage-python/lib/*py*"]
    doc.install Dir["libs/python/doc/*"]
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
    pyincludes = Utils.popen_read("python-config --includes").chomp.split(" ")
    pylib = Utils.popen_read("python-config --ldflags").chomp.split(" ")

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
