class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_72_0.tar.bz2"
  sha256 "59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "c15c8bf03d5ca454c93782648f700c1149c164bec8334561ef3727eee0f0435a" => :catalina
    sha256 "12e538b3468eff6e1afe41cbe595a389473ad37972fbc1ea69a5abc37ead890e" => :mojave
    sha256 "d0ff391db5f8864d6025e654708a84629aba54d59bdf7b366a6eb7cdca808918" => :high_sierra
  end

  depends_on "boost"

  uses_from_macos "python@2"

  # Fix build on Xcode 11.4
  patch do
    url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
    sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
    directory "tools/build"
  end

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
