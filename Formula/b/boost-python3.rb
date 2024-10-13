class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.86.0/boost-1.86.0-b2-nodocs.tar.xz"
  sha256 "a4d99d032ab74c9c5e76eddcecc4489134282245fffa7e079c5804b92b45f51d"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "66e23ad361052f87a6df6b7afaa5724df91f2ffaa482a6795ede1e0832d7b117"
    sha256 cellar: :any,                 arm64_sonoma:   "f2f55396a7afed649ea03117ac9ac111ed9bcf9d3ce4a0d2bf709e17c41652fc"
    sha256 cellar: :any,                 arm64_ventura:  "375db655b7ec5f3baa117e2159871434646d150217ab1505bb3e985c4ad66746"
    sha256 cellar: :any,                 arm64_monterey: "398d0edf6be250a569c26c27f74fefa4582e98df83beabd16565b4fe1d275840"
    sha256 cellar: :any,                 sonoma:         "37d7b06e4e101373807fa3d55ea0962bd7ca375734e63fcd05a0ded18b27a334"
    sha256 cellar: :any,                 ventura:        "db5fd6cdd07b5fdc534a420a119dfab593733a25e0af55b6899c149fe63b8910"
    sha256 cellar: :any,                 monterey:       "a0181c63ba6f93cbc495a6f0664fe7d45db3e1754a20ac8ffda46572866fa19a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d0f76e68afe7ed1f5bfc311afc9a7b260b842081a3c988494ce121cea7fe12d"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.12"

  # Backport support for numpy>=2
  patch do
    url "https://github.com/boostorg/python/commit/0474de0f6cc9c6e7230aeb7164af2f7e4ccf74bf.patch?full_index=1"
    sha256 "ac4f3e7bd4609c464a493cfe6a0e416bcd14fdadfc5c9f59a4c7d14e19aea80b"
    directory "libs/python"
  end
  patch do
    url "https://github.com/boostorg/python/commit/99a5352b5cf790c559a7b976c1ba99520431d9d1.patch?full_index=1"
    sha256 "6a15028cb172ebbf3480d3f00d7d5f6cf03d2d3f7f8baf20b9f4250b43da16aa"
    directory "libs/python"
  end

  def python3
    "python3.12"
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

    system ENV.cxx, "-shared", "-fPIC", "-std=c++14", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
