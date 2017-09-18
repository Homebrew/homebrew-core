class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.4.tar.gz"
  sha256 "408bb2f16eaad316be7ff6b4c867be04d8d57eb6e2642e168e992a51b82bb487"

  bottle do
    sha256 "7f06479f738e72a41b0c0c802cd236f64d3e45dd0541fcc2420b74c6e8908119" => :high_sierra
    sha256 "d907376ebb93b532858e76908a7ed2edc5ff50efa6c2692e9f688f1cf761122f" => :sierra
    sha256 "c5537b2271427fd448bd473d109f5a6cc0f7eab64c111ecac73cc02c3b368129" => :el_capitan
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

  # Fix "error: use of undeclared identifier 'atof'"
  # Reported 14 Sep 2017 https://github.com/POV-Ray/povray/issues/317
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e5017df/povray/cstdlib.diff"
    sha256 "bfd65f6634987f06d64a62fae71c1e72226a6242b7d7c8f7ef618d63e29b8553"
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
      --with-boost=#{Formula["boost"].opt_prefix}
      --without-libsdl
      --without-x
    ]

    args << "--with-openexr=#{Formula["openexr"].opt_prefix}" if build.with? "openexr"

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
