class BoostPython < Formula
  desc "C++ library for C++/Python interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
  sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "7eb61418c5c91034a7bc00cd5b56070a901afa4adfd3a7c0551e3809da4673a1" => :high_sierra
    sha256 "1821cfeabaeafe8ab6e003a8715fdff1c481afee0ebdef423082a321bc24d505" => :sierra
    sha256 "0d49ef79a0be83226cdb0fb2b010f6bcc867ce343fa980aee2ddb6356327688f" => :el_capitan
  end

  option "without-python", "Build without python 2 support"

  depends_on "python3" => :optional
  depends_on "boost"

  needs :cxx11

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi,single",
            "link=shared,static"]

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    # disable python detection in bootstrap.sh; it guesses the wrong include directory
    # for Python 3 headers, so we configure python manually in user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    Language::Python.each_python(build) do |python, version|
      py_prefix = `#{python} -c "from __future__ import print_function; import sys; print(sys.prefix)"`.strip
      py_include = `#{python} -c "from __future__ import print_function; import distutils.sysconfig; print(distutils.sysconfig.get_python_inc(True))"`.strip
      open("user-config.jam", "w") do |file|
        # Force boost to compile with the desired compiler
        file.write "using darwin : : #{ENV.cxx} ;\n"
        file.write <<~EOS
          using python : #{version}
                       : #{python}
                       : #{py_include}
                       : #{py_prefix}/lib ;
        EOS
      end

      system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}", "--with-libraries=python",
                               "--with-python=#{python}", "--with-python-root=#{py_prefix}"

      system "./b2", "--build-dir=build-#{python}", "--stagedir=stage-#{python}",
                     "python=#{version}", *args
    end

    lib.install Dir["stage-python3/lib/*py*"] if build.with?("python3")
    lib.install Dir["stage-python/lib/*py*"] if build.with?("python")
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
    Language::Python.each_python(build) do |python, _|
      pyflags = (`#{python}-config --includes`.strip + " " +
                 `#{python}-config --ldflags`.strip).split(" ")
      system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_#{python}", "-o", "hello.so", *pyflags
      output = `#{python} -c "from __future__ import print_function; import hello; print(hello.greet())"`
      assert_match "Hello, world!", output
    end
  end
end
