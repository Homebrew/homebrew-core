class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2"
  sha256 "d73a8da01e8bf8c7eda40b4c84915071a8c8a0df4a6734537ddde4a8580524ee"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "a417f98b320baf0eaad0c73f71cf93afad1c15ec270c648f6e8bf657ca936c44" => :catalina
    sha256 "007c36bd83c74a8337de124730544b5ea145ddaed5708451d1fb0e1f8dfa75cb" => :mojave
    sha256 "2851b897d46a0f84ad4561050804edc361b954c8987da71a0374aa3eab1c8966" => :high_sierra
    sha256 "bbfedf505fa8c0068acba3bd2b6d45910fc6fc21ce7975f06d19412621e3ea87" => :sierra
  end

  depends_on "boost"

  def install
    # "layout" should be synchronized with boost
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      threading=multi,single
      link=shared,static
    ]

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
