class BoostPython3AT168 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
  sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"

  keg_only :versioned_formula

  depends_on "boost@1.68"
  depends_on "python"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/45/ba/2a781ebbb0cd7962cc1d12a6b65bd4eff57ffda449fdbbae4726dc05fbc3/numpy-1.15.2.zip"
    sha256 "27a0d018f608a3fe34ac5e2b876f4c23c47e38295c47dd0775cc294cd2614bc1"
  end

  needs :cxx14

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

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    # disable python detection in bootstrap.sh; it guesses the wrong include
    # directory for Python 3 headers, so we configure python manually in
    # user-config.jam below.
    inreplace "bootstrap.sh", "using python", "#using python"

    pyver = Language::Python.major_minor_version "python3"
    py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    numpy_site_packages = buildpath/"homebrew-numpy/lib/python#{pyver}/site-packages"
    numpy_site_packages.mkpath
    ENV["PYTHONPATH"] = numpy_site_packages
    resource("numpy").stage do
      system "python3", *Language::Python.setup_install_args(buildpath/"homebrew-numpy")
    end

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using darwin : : #{ENV.cxx} ;
      using python : #{pyver}
                   : python3
                   : #{py_prefix}/include/python#{pyver}m
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python3",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3", "--stagedir=stage-python3",
                   "python=#{pyver}", *args

    lib.install Dir["stage-python3/lib/*py*"]
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

    pyincludes = Utils.popen_read("python3-config --includes").chomp.split(" ")
    pylib = Utils.popen_read("python3-config --ldflags").chomp.split(" ")
    pyver = Language::Python.major_minor_version("python3").to_s.delete(".")

    system ENV.cxx, "-shared", "hello.cpp", "-std=c++14", "-stdlib=libc++",
           "-I#{opt_include}", "-L#{opt_lib}", "-lboost_python#{pyver}", "-o",
           "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output("python3", output, 0)
  end
end
