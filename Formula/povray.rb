class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.5.tar.gz"
  sha256 "ade4d12ea8b7fe9188e78cf43b0b70608853ed4b511e285971675ef6a4fd9b0e"

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

  needs :cxx11

  def install
    # Boost 1.66 compat
    # Fix undefined symbol error for boost::system::generic_category
    # Reported 1 Jan 2018 https://github.com/POV-Ray/povray/issues/341
    inreplace "unix/configure.ac",
              "[[boost::defer_lock_t(); return 0;]])],",
              "[[boost::mutex m; boost::defer_lock_t(); return 0;]])],"

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
