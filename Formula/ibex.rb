class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.3.0.tar.gz"
  sha256 "637cd0d3bdae5f72867264fa9349a4f86023ac34b6d01ca0bec3618bc38d4a79"
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
    # Test failure "uncaught exception of type ibex::DimException"
    # Same as upstream fix https://github.com/ibex-team/ibex-lib/commit/1c882ef2
    if build.stable?
      inreplace "examples/slam/slam1.cpp",
        "x,dist(x[t],beacons[b])=d[t][b]);",
        "x,dist(transpose(x[t]),beacons[b])=d[t][b]);"
    end

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
