class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  license "BSL-1.0"
  revision 1
  head "https://github.com/boostorg/boost.git", branch: "master"

  stable do
    url "https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.bz2"
    sha256 "1e19565d82e43bc59209a168f5ac899d3ba471d55c7610c677d4ccf2c9c500c0"

    # Fix enum_type_object type on Python 3.11. Remove in the next release
    patch do
      url "https://github.com/boostorg/python/commit/a218babc8daee904a83f550fb66e5cb3f1cb3013.patch?full_index=1"
      sha256 "8fd377639faf0a26c80ba8f8dda354a9b6f966d7e1bfeadad9050a31cc4e2773"
      directory "libs/python"
    end
  end

  livecheck do
    formula "boost"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14298501ceac305a45dd7e347c6169490679476976c284ffb296b38e3f8cd29f"
    sha256 cellar: :any,                 arm64_monterey: "dc3ccc9dd8e4acbb59e44787bffbce7e7c26bb8cf544d7ed7a5f52d8062edcd9"
    sha256 cellar: :any,                 arm64_big_sur:  "4e6de376843f862a5eb752545f2c6011d01b8c2b9342ebee3b8876b08cfed90e"
    sha256 cellar: :any,                 ventura:        "70de842539071a02d65368f301661755b26ad5b3618c6e591dd89b5b340b420e"
    sha256 cellar: :any,                 monterey:       "9766f19f1771e7c753d99d4a4870a913499df2c38b71e8111896a657c15ab05c"
    sha256 cellar: :any,                 big_sur:        "826a6656b672c6c52c92b3f0c9755ee71e05ec21993221d7cd9517bedaf3e756"
    sha256 cellar: :any,                 catalina:       "d3334e9369796845fe33a521727187098753202e8d7f4e4a67b699a5f822d878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dfbb560a205235b650d83e4e6f36effc6bc0b053afc0575a39e678dad3b7b55"
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.11"

  def python3
    "python3.11"
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
