class BoostPython < Formula
  desc "C++ library for C++/Python interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.bz2"
  sha256 "9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81"
  revision 1
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "8377ee93d0bb678b2c69e9f2956607b4c04e4c226a780be60b452ac2d7e02de7" => :high_sierra
    sha256 "d811c19f1eef548746972475d98f68f431f62af075a9c9e984911f6cb45ebb75" => :sierra
    sha256 "37b52bcae4be5fb7db46487e494bc8c3da0ddbe2dab2e7f20ffba4e7eb3827e4" => :el_capitan
    sha256 "28e1853e51af2f853dfd84135a62215c3d3142126742648f1e76434f218756dc" => :yosemite
  end

  option "without-python", "Build without python 2 support"

  depends_on :python3 => :optional
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
