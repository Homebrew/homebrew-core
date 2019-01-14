class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.7.4.tar.gz"
  sha256 "2b32a1e51766476c9baab4017001e3e9ce2b6b102e2ac7492002305483607036"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "4de28b404a43504acf29619dfc5002b2ac7b5f7285d165cf2f69670023678e58" => :mojave
    sha256 "c0fb9de7e874f4f16c9d93c8e5aeb57c9dccdc475e95af9a46e6b92319763933" => :high_sierra
    sha256 "c59612cbd75e27f3a996813cb6e270faf9be5fe0a096b74355533f3f5515f70c" => :sierra
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]

  needs :cxx11

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--enable-shared",
                                 "--lp-lib=soplex",
                                 "--with-optim"
    system "./waf", "install"

    pkgshare.install %w[examples plugins/solver/benchs]
    (pkgshare/"examples/symb01.txt").write <<~EOS
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    ENV.cxx11

    cp_r (pkgshare/"examples").children, testpath

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub!(/CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd")
      s.gsub!(/LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex")
    end

    (1..8).each do |n|
      system "make", "lab#{n}"
      system "./lab#{n}"
    end

    (1..3).each do |n|
      system "make", "-C", "slam", "slam#{n}"
      system "./slam/slam#{n}"
    end
  end
end
