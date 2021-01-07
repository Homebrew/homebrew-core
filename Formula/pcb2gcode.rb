class Pcb2gcode < Formula
  desc "Command-line tool for isolation, routing and drilling of PCBs"
  homepage "https://github.com/pcb2gcode/pcb2gcode"
  url "https://github.com/pcb2gcode/pcb2gcode/archive/v2.2.0.tar.gz"
  sha256 "b6c0daeeaaf1a53fda9d7821694839dcb3c0b2c4115cfc1a748d0e51a8676aa8"
  license "GPL-3.0-or-later"
  head "https://github.com/pcb2gcode/pcb2gcode.git"

  bottle do
    cellar :any
    sha256 "ebeae69a3b6c8ce423c361efbf21914582de1953dd1435829249d1179dc8d59c" => :big_sur
    sha256 "25c1b52ff023dd2137810355ba205d3be3e065ccf90851b2f49329f665ff54a5" => :catalina
    sha256 "cc6d2180685fa076d25a24db6ccd39b7346f28ad52f90a1d72cc3d22bfe840df" => :mojave
  end

  # Release 2.0.0 doesn't include an autoreconfed tarball
  # glibmm, gtkmm and librsvg are used only in unittests,
  # and are therefore not needed at runtime.
  depends_on "atkmm" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cairomm@1.14" => :build
  depends_on "glibmm" => :build
  depends_on "gtkmm" => :build
  depends_on "librsvg" => :build
  depends_on "libsigc++@2" => :build
  depends_on "libtool" => :build
  depends_on "pangomm" => :build
  depends_on "pkg-config" => :build
  depends_on "gerbv"

  # Upstream maintainer claims that the geometry library from boost >= 1.67
  # is severely broken. Remove the vendoring once fixed.
  # See https://github.com/Homebrew/homebrew-core/pull/30914#issuecomment-411662760
  # and https://svn.boost.org/trac10/ticket/13645
  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
    sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"

    # Fix build on Xcode 11.4
    patch do
      url "https://github.com/boostorg/build/commit/b3a59d265929a213f02a451bb63cea75d668a4d9.patch?full_index=1"
      sha256 "04a4df38ed9c5a4346fbb50ae4ccc948a1440328beac03cb3586c8e2e241be08"
      directory "tools/build"
    end
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

      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

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
