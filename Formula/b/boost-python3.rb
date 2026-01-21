class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.90.0/boost-1.90.0-b2-nodocs.tar.xz"
  sha256 "9e6bee9ab529fb2b0733049692d57d10a72202af085e553539a05b4204211a6f"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77000c87c322c35f47f19ba70d2ee7e96454858afcd319e40a3779752bf358a5"
    sha256 cellar: :any,                 arm64_sequoia: "e38c32230702a701b9925647b7e60d1bdb4898f4f28edc385616677d12ae4248"
    sha256 cellar: :any,                 arm64_sonoma:  "73034591865ce9f6f06788722f803643e3bb46c3f476efb9bca0a53326bde841"
    sha256 cellar: :any,                 sonoma:        "4a0b132affb3cd982ee303ca1935260a3bd2f9cba79b08e50cb3c3ece1d47a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc66b1167e63982f9b637a72b9f3aec2dfedd97796ee6cce51e8de491963f878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d63c94b12444cb43b121226bd0e0c8d02e2a89f91ca18040601a2a83ea2292"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
