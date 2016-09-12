class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.3.1.tar.gz"
  sha256 "a5aa561e485229dc58100673d0b10df5c0e7c3661b57530ed68a4d84cdfe3940"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "3f02be452b5cf8c02fe5c9b94f5046ccd82f5640d1b3b8709a5cb32089631f9b" => :el_capitan
    sha256 "11790b747655c7b726d8a83e58e569660561734052a7667f07d54dd064178b29" => :yosemite
    sha256 "01b0a1a82ffa341626c76f858d5387a3a0246d7b30a01f6ab6fef3d4a05d993e" => :mavericks
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

    system "make", *%w[ctc01 ctc02 symb01 solver01 solver02]
    system "make", "-C", "slam", *%w[slam1 slam2 slam3]
    %w[ctc01 ctc02 symb01].each { |a| system "./#{a}" }
    %w[solver01 solver02].each { |a| system "./#{a}", "c3D.bch", "1e-05", "10" }
    %w[slam1 slam2 slam3].each { |a| system "./slam/#{a}" }
  end
end
