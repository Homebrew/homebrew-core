class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.3.tar.gz"
  sha256 "baa4c7f04415fbc2a99cfab6da4d33a7ca018d985fc71701c603a67c6b0a9426"

  bottle do
    sha256 "2a9da6569fb38e6f997da1ed33ce07419d1ddf38bdc13c0e44c8ee3d677228e2" => :sierra
    sha256 "fb5fa0f00589439a4ef06408006e65c1ffaa1683dcc84fdf80ea0ceab621750c" => :el_capitan
    sha256 "7ad20b464b16b59761ff7295b88639e3a3bd9f44b03351bf9aff78e17e60f4fe" => :yosemite
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr" => :optional

  deprecated_option "use-openexr" => "with-openexr"

  # Fixes compatibility with boost 1.65.0
  # Adapted from https://github.com/POV-Ray/povray/pull/318
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/8443970b254/povray/boost-1.65.0.diff"
    sha256 "19f9826cb2287bb16e8d3d21da5ca73eb848ff9a9e719c110bae562b6fcc028e"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --without-libsdl
      --without-x
    ]

    args << "--with-openexr=#{HOMEBREW_PREFIX}" if build.with? "openexr"

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh",
                /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Condensed version of `share/povray-3.7/scripts/allscene.sh` that only
    # renders variants of the famous Utah teapot as a quick smoke test.
    scenes = Dir["#{share}/povray-3.7/scenes/advanced/teapot/*.pov"]
    assert !scenes.empty?, "Failed to find test scenes."
    scenes.each do |scene|
      system "#{share}/povray-3.7/scripts/render_scene.sh", ".", scene
    end
  end
end
