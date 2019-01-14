class BoostPythonAT159 < Formula
  desc "C++ library for C++/Python interoperability"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
  sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"
  revision 1

  bottle do
    rebuild 1
    sha256 "41234d5b67b98b22b823c701b88874caaca57053e18f7069f3a40e308e882a2c" => :mojave
    sha256 "ab4e76cbdd45a69200580916a736c1aa9d0b76d25ecedd72f3e017804375d43b" => :high_sierra
    sha256 "50b61de8e17320c4bd1d095a165cbacb6505631b825133135e4517999079488e" => :sierra
    sha256 "79d9b0b2a2af2ddf37af79cc611d27733b3dbba6c5ca5bb86868a5521e9e37dd" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "boost@1.59"
  depends_on "python@2"

  def install
    # fix make_setter regression
    # https://github.com/boostorg/python/pull/40
    inreplace "boost/python/data_members.hpp",
              "# if BOOST_WORKAROUND(__EDG_VERSION__, <= 238)",
              "# if !BOOST_WORKAROUND(__EDG_VERSION__, <= 238)"

    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "--user-config=user-config.jam",
            "threading=multi,single",
            "link=shared,static"]

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

    lib.install Dir["stage-python2.7/lib/*py*"]
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
      boost_python = (python == "python3") ? "boost_python3" : "boost_python"
      pyflags = `#{python}-config --includes`.strip.split(" ") +
                `#{python}-config --ldflags`.strip.split(" ")
      system ENV.cxx, "-shared", "hello.cpp", "-I#{Formula["boost159"].opt_include}",
                      "-L#{lib}", "-l#{boost_python}", "-o", "hello.so", *pyflags
      output = `#{python} -c "from __future__ import print_function; import hello; print(hello.greet())"`
      assert_match "Hello, world!", output
    end
  end
end
