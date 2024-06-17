class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://github.com/boostorg/boost/releases/download/boost-1.85.0/boost-1.85.0-b2-nodocs.tar.xz"
  sha256 "09f0628bded81d20b0145b30925d7d7492fd99583671586525d5d66d4c28266a"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "75619380caacdbc14f461b65f31718918982cd78bed36bc94b6e66a645551f60"
    sha256 cellar: :any,                 arm64_ventura:  "3e9f0925f97bc07b6114bc361c209b68d27c8c07bce233dd2cd6bfcadadc772e"
    sha256 cellar: :any,                 arm64_monterey: "3515f99d2f5198836f7ede29d65b4a3d7452d29de7e0a176e43813a8f0f9ad25"
    sha256 cellar: :any,                 sonoma:         "37ef3943e0a45f8c0663170f513159bc2b60b67318fc49b1f6a9959c0aff45de"
    sha256 cellar: :any,                 ventura:        "f26d01c318e58e84c4140b28e2bfeddaae7c9d7eead184bfbeb2be1685ae5913"
    sha256 cellar: :any,                 monterey:       "f49d9bbe2505905d59a1397febd3c27fcc24a55e8478445fb920543e3aac7624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d9ce9c288bcb5f362890cdee900170efd3e7d7a9f02447ce5a372de08a2218"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.12"

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

    system ENV.cxx, "-shared", "-fPIC", "-std=c++14", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}",
                    "-o", "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output(python3, output, 0)
  end
end
