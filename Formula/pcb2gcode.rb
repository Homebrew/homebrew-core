class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.0.0.tar.gz"
  sha256 "3b7e8cdc58852294d95b0ed705933f528a9e56428863490f5a27f22153cd713e"
  head "https://github.com/pcb2gcode/pcb2gcode.git"

  bottle do
    cellar :any
    sha256 "dd20b8d80aac8a123f6b84ec4400ea50c84691453b40b1afbd9e1f8923c64d55" => :mojave
    sha256 "2cbc765fb54196489e65e894336e86be43e45adec4b76c780ae8b6a46b789c65" => :high_sierra
    sha256 "4e87558d43b89905e3bf305c0e066fd43a8d09209da6902db00fa65d12ee09a4" => :sierra
  end

  # Release 2.0.0 doesn't include an autoreconfed tarball
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gerbv"
  depends_on "gtkmm"
  depends_on "librsvg"

  # Upstream maintainer claims that the geometry library from boost >= 1.67
  # is severely broken. Remove the vendoring once fixed.
  # See https://github.com/Homebrew/homebrew-core/pull/30914#issuecomment-411662760
  # and https://svn.boost.org/trac10/ticket/13645
  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
    sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"
  end

  def install
    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
      end

      bootstrap_args = %W[
        --prefix=#{buildpath}/boost
        --libdir=#{buildpath}/boost/lib
        --with-libraries=program_options
        --without-icu
      ]

      args = %W[
        --prefix=#{buildpath}/boost
        --libdir=#{buildpath}/boost/lib
        -d2
        -j#{ENV.make_jobs}
        --ignore-site-config
        --layout=tagged
        --user-config=user-config.jam
        install
        threading=multi
        link=static
        optimization=space
        variant=release
        cxxflags=-std=c++11
      ]

      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end

      system "./bootstrap.sh", *bootstrap_args
      system "./b2", "headers"
      system "./b2", *args
    end

    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost=#{buildpath}/boost",
                          "--enable-static-boost"
    system "make", "install"
  end

  test do
    (testpath/"front.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11R,2.032000X2.032000*%
      %ADD12O,2.032000X2.032000*%
      %ADD13C,0.250000*%
      D11*
      X127000000Y-63500000D03*
      D12*
      X127000000Y-66040000D03*
      D13*
      X124460000Y-66040000D01*
      X124460000Y-63500000D01*
      X127000000Y-63500000D01*
      M02*
    EOS
    (testpath/"edge.gbr").write <<~EOS
      %FSLAX46Y46*%
      %MOMM*%
      G01*
      %ADD11C,0.150000*%
      D11*
      X123190000Y-67310000D02*
      X128270000Y-67310000D01*
      X128270000Y-62230000D01*
      X123190000Y-62230000D01*
      X123190000Y-67310000D01*
      M02*
    EOS
    (testpath/"drill.drl").write <<~EOS
      M48
      FMAT,2
      METRIC,TZ
      T1C1.016
      %
      G90
      G05
      M71
      T1
      X127.Y-63.5
      X127.Y-66.04
      T0
      M30
    EOS
    (testpath/"millproject").write <<~EOS
      dpi=500
      metric=true
      zchange=10
      zsafe=5
      mill-feed=600
      mill-speed=10000
      offset=0.1
      zwork=-0.05
      drill-feed=1000
      drill-speed=10000
      zdrill=-2.5
      bridges=0.5
      bridgesnum=4
      cut-feed=600
      cut-infeed=10
      cut-speed=10000
      cutter-diameter=3
      fill-outline=true
      outline-width=0.15
      zbridges=-0.6
      zcut=-2.5
      al-front=true
      al-probefeed=100
      al-x=15
      al-y=15
      software=LinuxCNC
    EOS
    system "#{bin}/pcb2gcode", "--front=front.gbr",
                               "--outline=edge.gbr",
                               "--drill=drill.drl"
  end
end
