class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.89.0/boost-1.89.0-b2-nodocs.tar.xz"
  sha256 "875cc413afa6b86922b6df3b2ad23dec4511c8a741753e57c1129e7fa753d700"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19318e145dda8b1a0033e8d4c50b14e8d28bfb4372fd847c6b5bce1a118b5258"
    sha256 cellar: :any,                 arm64_sequoia: "9fc78a9b25bc31ea5d2e5252709b685d5c8a8bd7fb4c0f4e89113f61f0d85135"
    sha256 cellar: :any,                 arm64_sonoma:  "f6fc46a18f6c019e3279a23f62fedf624f7eeb08f05e14e667e5de401155f4fc"
    sha256                               arm64_ventura: "f30ee8fdeb54b9a69be3d397dc3d56513859ddc709dcb0642cc1fbf27f9198f8"
    sha256 cellar: :any,                 sonoma:        "b667df9899f2b8a1d5b560d4d8e43228f3b6541b2e1dd3e660966396a6a822a7"
    sha256 cellar: :any,                 ventura:       "1fd70752993ccd34bef6688d7cc840954ab6f1be78b371c2c67c7e044255c528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc4781b134777c0b754521072e28eb6d825b64a9b381c57000a1dd372760a767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81d4ec0fd2648db5a18efd3d3100b12142b7b90c7c6b312e229dfeee7ff0f171"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    # "layout" should be synchronized with boost
    args = %W[
      -d2
      -j#{ENV.make_jobs}
      --layout=system
      --user-config=user-config.jam
      install
      threading=multi
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    # Avoid linkage to boost container and graph modules
    # Issue ref: https://github.com/boostorg/boost/issues/985
    args << "linkflags=-Wl,-dead_strip_dylibs" if OS.mac?

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version python3
    py_prefix = if OS.mac?
      Formula["python@#{pyver}"].opt_frameworks/"Python.framework/Versions"/pyver
    else
      Formula["python@#{pyver}"].opt_prefix
    end

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using #{OS.mac? ? "darwin" : "gcc"} : : #{ENV.cxx} ;
      using python : #{pyver}
                   : #{python3}
                   : #{py_prefix}/include/python#{pyver}
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}",
                             "--libdir=#{lib}",
                             "--with-libraries=python",
                             "--with-python=#{python3}",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3/lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install buildpath.glob("install-python3/lib/*{python,numpy}*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/*{python,numpy}*")

    # Fix the path to headers installed in `boost` formula
    cmake_configs = lib.glob("cmake/boost_{python,numpy}*/boost_{python,numpy}-config.cmake")
    inreplace cmake_configs, '(_BOOST_INCLUDEDIR "${_BOOST_CMAKEDIR}/../../include/" ABSOLUTE)',
                             "(_BOOST_INCLUDEDIR \"#{Formula["boost"].opt_include}/\" ABSOLUTE)"
  end

  test do
    (testpath/"hello.cpp").write <<~CPP
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    CPP

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system ENV.cxx, "-shared", "-fPIC", "-std=c++14", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~PYTHON
      import hello
      print(hello.greet())
    PYTHON
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
