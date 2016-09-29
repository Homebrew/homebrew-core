class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.3.1.tar.gz"
  sha256 "a5aa561e485229dc58100673d0b10df5c0e7c3661b57530ed68a4d84cdfe3940"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "c7ef1c9af1eb14b3c8879d18fdb61a146f0ea44f76117ed7e89dbdc6499da857" => :sierra
    sha256 "3f02389690062104e17fed76c944451574994d1df58c5042683e6cf3195783a5" => :el_capitan
    sha256 "e1ced99fb58fe29cb5c4067d20993f20f09011daae209db84eefdac9fd8cc435" => :yosemite
    sha256 "3cc2d3e52d4307f8fda2f1f8eba580af3eb2b91573311550c48916366ab4edbd" => :mavericks
  end

  option "with-java", "Enable Java bindings for CHOCO solver."
  option "with-ampl", "Use AMPL file loader plugin"
  option "without-ensta-robotics", "Don't build the Contractors for robotics (SLAM) plugin"
  option "without-param-estim", "Don't build the Parameter Estimation (enhanced Q-intersection algorithm) plugin"

  depends_on :java => ["1.8+", :optional]
  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  def install
    if build.with?("java") && build.with?("ampl")
      odie "Cannot set options --with-java and --with-ampl simultaneously for now."
    end

    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-affine
      --with-optim
    ]

    args << "--with-jni" if build.with? "java"
    args << "--with-ampl" if build.with? "ampl"
    args << "--with-ensta-robotics" if build.with? "ensta-robotics"
    args << "--with-param-estim" if build.with? "param-estim"

    system "./waf", "configure", *args
    system "./waf", "install"

    pkgshare.install %w[examples benchs]
    (pkgshare/"examples/symb01.txt").write <<-EOS.undent
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    cp pkgshare/"benchs/cyclohexan3D.bch", testpath/"c3D.bch"

    # so that pkg-config can remain a build-time only dependency
    inreplace %w[makefile slam/makefile] do |s|
      s.gsub! /CXXFLAGS.*pkg-config --cflags ibex./,
              "CXXFLAGS := -ffloat-store -I#{include} -I#{include}/ibex"
      s.gsub! /LIBS.*pkg-config --libs  ibex./,
              "LIBS := -L#{lib} -libex -lprim -lClp -lCoinUtils -lm"
    end

    system "make", "ctc01", "ctc02", "symb01", "solver01", "solver02"
    system "make", "-C", "slam", "slam1", "slam2", "slam3"
    %w[ctc01 ctc02 symb01].each { |a| system "./#{a}" }
    %w[solver01 solver02].each { |a| system "./#{a}", "c3D.bch", "1e-05", "10" }
    %w[slam1 slam2 slam3].each { |a| system "./slam/#{a}" }
  end
end
