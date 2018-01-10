class BoostPythonAT159 < Formula
  desc "C++ library for C++/Python interoperability"
  homepage "https://www.boost.org"
  url "https://downloads.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.bz2"
  sha256 "727a932322d94287b62abb1bd2d41723eec4356a7728909e38adb65ca25241ca"

  bottle do
    cellar :any
    sha256 "ba33ce18f24b422ec0440400e8418456b6b1de04c111f46d55cfbb24acc15b72" => :high_sierra
    sha256 "72e56d744c5369bcb8de95eee92182ca9cfe8e580d596473069ca69c0b23b3d6" => :sierra
    sha256 "1adf1e1e570236fe2f67367d2ac17e83ade9d1b25e5e356bff23ce52d0117c8a" => :el_capitan
    sha256 "ad13c2d6ceaec797943327a08babffc6d284fe89ec7f60170a362fa134e1429b" => :yosemite
  end

  keg_only :versioned_formula

  option :cxx11

  option "without-python", "Build without python 2 support"
  depends_on "python3" => :optional

  if build.cxx11?
    depends_on "boost@1.59" => "c++11"
  else
    depends_on "boost@1.59"
  end

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

    # Build in C++11 mode if boost was built in C++11 mode.
    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    if build.cxx11?
      args << "cxxflags=-std=c++11"
      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end
    elsif Tab.for_name("boost159").cxx11?
      odie "boost159 was built in C++11 mode so boost-python159 must be built with --c++11."
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
      pyflags = (`#{python}-config --includes`.strip +
                 `#{python}-config --ldflags`.strip).split(" ")
      system ENV.cxx, "-shared", "hello.cpp", "-I#{Formula["boost159"].opt_include}",
                      "-L#{lib}", "-lboost_#{python}", "-o", "hello.so", *pyflags
      output = `#{python} -c "from __future__ import print_function; import hello; print(hello.greet())"`
      assert_match "Hello, world!", output
    end
  end
end
