class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.92.0/boost-1.92.0-b2-nodocs.tar.xz"
  sha256 "ea7b982002cc9dfbe59b0b217b206f470dc75f3de0bb2973d844118934d82411"
  license "BSL-1.0"
  compatibility_version 2
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ba993fc843a2e0491bafb23fa3e66e83e75eb7491a5ca68e816ea448cf12be2a"
    sha256 cellar: :any, arm64_sequoia: "a3b8c0c72e47aa910606620c2dc8ff6f4bf1de2402e10e0318a832d6a93e113f"
    sha256 cellar: :any, arm64_sonoma:  "b19c18377989359c04eac34969c077d73e71a082cfae0cef4a3939dc08b4030a"
    sha256 cellar: :any, sonoma:        "6fee4f21a171aeab2bd4d329f0a7d97a360328c919708e4b8ccc084968598ba9"
    sha256 cellar: :any, arm64_linux:   "200d378d1813f12a20f49e398d7ea5f13d310dfdec560c81af02a277c0608075"
    sha256 cellar: :any, x86_64_linux:  "1d7a782ce31e27693e78b3178202ec5acf948d5e7e47c57a772dbf9f5119e046"
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

    # Keep cxxflags aligned with `boost`
    args << "cxxflags=-std=c++17"
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
      formula_opt_prefix("python@#{pyver}")
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
                             "(_BOOST_INCLUDEDIR \"#{formula_opt_include("boost")}/\" ABSOLUTE)"
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

    system ENV.cxx, "-shared", "-fPIC", "-std=c++17", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~PYTHON
      import hello
      print(hello.greet())
    PYTHON
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
