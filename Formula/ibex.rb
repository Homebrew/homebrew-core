class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "https://web.archive.org/web/20190826220512/www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.8.7.tar.gz"
  sha256 "b80da9f6edecaf93edc00c7e7c630ae6cf934ce9ce061debb630f027e69b5c97"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "0de9cd95f329d455905ef0d562c4bf116b7a634adc70296830da39259b21130f" => :catalina
    sha256 "ffebafe7aec3708cf61e3f248c891cca974d904c0e987294e45cbf0bf612d13b" => :mojave
    sha256 "91500e1cd76da6db5afa6e5c0ac70ccf09b2ce3036d4544b2abd21a4ec3beb78" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on :macos # Due to Python 2

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    system "./waf", "configure", "--prefix=#{prefix}",
                                 "--enable-shared",
                                 "--lp-lib=soplex",
                                 "--with-optim"
    system "./waf", "install"

    pkgshare.install %w[examples benchs/solver]
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
