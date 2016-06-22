class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.3.0.tar.gz"
  sha256 "637cd0d3bdae5f72867264fa9349a4f86023ac34b6d01ca0bec3618bc38d4a79"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "d69c328e3f1f61e41c15b7b60f059f36ce8f94c0df3f66f2bfeec11bdd321059" => :el_capitan
    sha256 "5507a4ee541c75034778857faaae9faee078d0d6c588af9462ed863cf7326eec" => :yosemite
    sha256 "be6430760bcc3d1a23c9fa48a81d641d528dd4f4275719e7332456b452f4c668" => :mavericks
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
