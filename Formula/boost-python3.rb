class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2"
  sha256 "1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b00e0557668bb9a167b7aa1864db33a4b8505066288459ab05ad10745398df2"
    sha256 cellar: :any,                 arm64_big_sur:  "646249b68231b84630fd631790ab80e9d13b7a7cb62bafa8e08fb35c926380ba"
    sha256 cellar: :any,                 monterey:       "abd27c9a20d98a3f3acadc55225c582dcbe3457080e9f66bb480b14f549771c1"
    sha256 cellar: :any,                 big_sur:        "0960734129fa8ddc8f3f2b7d3d35efc63d67677f99c3f1bbcb780197018ddbe8"
    sha256 cellar: :any,                 catalina:       "20af97eca0a0c3fb287c76c2972d15a2e01f43f4bf4484c90e11045b21667b4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b93830c083dd4e555e5f70e5ef7ab5afaaa2feb387c2837fbd8f82d62405efa"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.10"

  def python3
    "python3.10"
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

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

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

    lib.install buildpath.glob("install-python3/lib/*.*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/boost_python*")
    (lib/"cmake").install buildpath.glob("install-python3/lib/cmake/boost_numpy*")
    doc.install (buildpath/"libs/python/doc").children
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

    pyincludes = shell_output("#{python3}-config --includes").chomp.split
    pylib = shell_output("#{python3}-config --ldflags --embed").chomp.split
    pyver = Language::Python.major_minor_version(python3).to_s.delete(".")

    system ENV.cxx, "-shared", "-fPIC", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
