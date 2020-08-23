class BoostPython3 < Formula
  desc "C++ library for C++/Python3 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.73.0/source/boost_1_73_0.tar.bz2"
  mirror "https://dl.bintray.com/homebrew/mirror/boost_1_73_0.tar.bz2"
  sha256 "4eb3b8d442b426dc35346235c8733b5ae35ba431690e38c6a8263dce9fcbb402"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any
    sha256 "36a3b2ffacb47649b51e0b3031b8f67bf7dcd87e61dfd6d594610cb3e21a1acc" => :catalina
    sha256 "deda39650cec775da3e8a4915aec600cfd55b367f212be975bdcc70952f2e805" => :mojave
    sha256 "237b8dcaaa8fcdc72ef8a57e6e38675a82579b736f819707f28bbf5f644ceffa" => :high_sierra
  end

  depends_on "numpy" => :build
  depends_on "boost"
  depends_on "python@3.8"

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

    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    py_prefix = Formula["python@3.8"].opt_frameworks/"Python.framework/Versions/#{pyver}"

    # Force boost to compile with the desired compiler
    (buildpath/"user-config.jam").write <<~EOS
      using darwin : : #{ENV.cxx} ;
      using python : #{pyver}
                   : python3
                   : #{py_prefix}/include/python#{pyver}
                   : #{py_prefix}/lib ;
    EOS

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python3",
                             "--with-python-root=#{py_prefix}"

    system "./b2", "--build-dir=build-python3",
                   "--stagedir=stage-python3",
                   "--libdir=install-python3/lib",
                   "--prefix=install-python3",
                   "python=#{pyver}",
                   *args

    lib.install Dir["install-python3/lib/*.*"]
    (lib/"cmake").install Dir["install-python3/lib/cmake/boost_python*"]
    (lib/"cmake").install Dir["install-python3/lib/cmake/boost_numpy*"]
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

    pyincludes = shell_output("#{Formula["python@3.8"].opt_bin}/python3-config --includes").chomp.split(" ")
    pylib = shell_output("#{Formula["python@3.8"].opt_bin}/python3-config --ldflags --embed").chomp.split(" ")
    pyver = Language::Python.major_minor_version(Formula["python@3.8"].opt_bin/"python3").to_s.delete(".")

    system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_python#{pyver}", "-o",
           "hello.so", *pyincludes, *pylib

    output = <<~EOS
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output(Formula["python@3.8"].opt_bin/"python3", output, 0)
  end
end
