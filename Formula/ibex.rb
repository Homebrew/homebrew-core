class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  head "https://github.com/ibex-team/ibex-lib.git"

  stable do
    url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.2.0.tar.gz"
    sha256 "fa6f281d5f28db11fa8715569937b4d19bd24ab744d0c7f21674cc1552d674ee"

    # Patch the optional param-estim plugin build script
    patch do
      url "https://github.com/ibex-team/ibex-lib/pull/192.diff"
      sha256 "91cc070ad5464a5c19205228470161ff87a09df5b3aeaae2b65361319e509fbf"
    end
  end

  bottle do
    cellar :any
    sha256 "21744850c087156a1ced058b7c4ca6bc8521d0f29b97929b211f544f9284e3c9" => :el_capitan
    sha256 "8f3820e87fea2799f4789bf956803dadab7789e2c51c29567e339db4e08473b7" => :yosemite
    sha256 "51288d9af477d65a26f8f37bee74e07913df0e77be6bbc979758a8486a1d6fd3" => :mavericks
    sha256 "41327b6a0da9b8b2ed888c3c2c33d5f6ff061ea13eceb4b9e8b6e660049d624d" => :mountain_lion
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

    cd "examples" do
      ENV["PKG_CONFIG_PATH"] = "#{share}/pkgconfig"
      # Build Ibex examples
      system "make", *%w[ctc01 ctc02 symb01 solver01 solver02]
      # Build SLAM examples
      cd "slam" do
        system "make", *%w[slam1 slam2 slam3]
      end
    end

    pkgshare.install %w[examples benchs]
    (pkgshare/"examples/symb01.txt").write <<-EOS.undent
      function f(x)
        return ((2*x,-x);(-x,3*x));
      end
    EOS
  end

  test do
    cp_r "#{pkgshare}/examples/.", testpath

    # Base Ibex examples
    %w[ctc01 ctc02 symb01].each { |a| system "./#{a}" }
    # Ibex solver examples
    cp "#{pkgshare}/benchs/cyclohexan3D.bch", testpath
    %w[solver01 solver02].each { |a| system "./#{a}", "cyclohexan3D.bch", "1e-05", "10" }
    # Slam example (base Ibex)
    cd "slam" do
      %w[slam1 slam2 slam3].each { |a| system "./#{a}" }
    end
  end
end
