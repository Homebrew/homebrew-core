class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.6.0.tar.gz"
  sha256 "fe480af2fcf14b484cf2137ffb414ab4ebb402cf445687a04e45202ba88d3a8f"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "c38ad8be624e34076dc3c5758a968932b777db0bd304135e77ccc3f8896c71f7" => :high_sierra
    sha256 "dc78f48056adc99205820e93f44f515be9a654e154bb5da02b70044a965d25de" => :sierra
    sha256 "3f0f1711cd85b1c9ef4a8acd94a8ff4fae566e22478bc716405b9751c7562ab8" => :el_capitan
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
