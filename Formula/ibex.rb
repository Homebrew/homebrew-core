class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.6.0.tar.gz"
  sha256 "fe480af2fcf14b484cf2137ffb414ab4ebb402cf445687a04e45202ba88d3a8f"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "7b6399e309cce08ca90d9fb5079823edde266624c300d36af33dc6f67ed8e67d" => :high_sierra
    sha256 "ef2deaa7e7315bd9bbe3367b767cbefbfc1f9a1a91bd0464be83b9c6ad66d8f6" => :sierra
    sha256 "ef1b5894f381de2e629176702c7154fc94221ca5f15bf92c91d36fb0f0f4c9fc" => :el_capitan
  end

  option "with-java", "Enable Java bindings for CHOCO solver."
  option "with-ampl", "Use AMPL file loader plugin"
  option "without-ensta-robotics", "Don't build the Contractors for robotics (SLAM) plugin"

  depends_on :java => ["1.8+", :optional]
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  needs :cxx11

  def install
    ENV.cxx11

    # Reported 9 Oct 2017 https://github.com/ibex-team/ibex-lib/issues/286
    ENV.deparallelize

    if build.with?("java") && build.with?("ampl")
      odie "Cannot set options --with-java and --with-ampl simultaneously for now."
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-optim
      --lp-lib=soplex
    ]

    args << "--with-jni" if build.with? "java"
    args << "--with-ampl" if build.with? "ampl"
    args << "--with-param-estim" if build.with? "param-estim"

    system "./waf", "configure", *args
    system "./waf", "install"

    pkgshare.install %w[examples plugins/solver/benchs]
    (pkgshare/"examples/symb01.txt").write <<-EOS.undent
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r (pkgshare/"examples").children, testpath

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub! /CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -I#{include} -I#{include}/ibex "\
                          "-I#{include}/ibex/3rd"
      s.gsub! /LIBS.*pkg-config --libs  ibex./, "LIBS := -L#{lib} -libex"
    end

    system "make", "lab1", "lab2", "lab3", "lab4"
    system "make", "-C", "slam", "slam1", "slam2", "slam3"
    %w[lab1 lab2 lab3 lab4].each { |a| system "./#{a}" }
    %w[slam1 slam2 slam3].each { |a| system "./slam/#{a}" }
  end
end
