class Ibex < Formula
  desc "C++ library for constraint processing over real numbers."
  homepage "http://www.ibex-lib.org/"
  url "https://github.com/ibex-team/ibex-lib/archive/ibex-2.2.1.tar.gz"
  sha256 "67448e063559f409815be0075d4a1e9024f79e014ddf0cbbcaf6f716694df6e3"
  head "https://github.com/ibex-team/ibex-lib.git"

  bottle do
    cellar :any
    sha256 "5abdb26e6f429833331b3a59201b1dd000b0ee1f8a8a119ae3f64a406982fae9" => :el_capitan
    sha256 "065bd27248281bb02f351a0248a3a2753e83aa08ea8fb5ad8f01285161c68beb" => :yosemite
    sha256 "641812e10e130e6ef29c1f9410ac180230a2ef9c827be6c454695e3508955aac" => :mavericks
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
