class Ibex < Formula
  desc "C++ library for constraint processing over real numbers"
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.8.2.tar.gz"
  sha256 "ad432fcb0321f7fb1d73356f9cce5a28170fbda63466228e5d2be9673249a9ec"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "6c1dbbb8335aadff9789405547de3b460e703d47815aa5e9869c9f3b9b0f4080" => :mojave
    sha256 "979475ef4b84cab316facf3538c973afbf5063bd523f22c487512da0ec43ced3" => :high_sierra
    sha256 "97be69b76e5395e511f70934a33f4a25875a2db033cd11a64afef93db4a6c0ac" => :sierra
  end

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => [:build, :test]

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
