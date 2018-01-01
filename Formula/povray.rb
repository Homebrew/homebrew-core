class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.5.tar.gz"
  sha256 "ade4d12ea8b7fe9188e78cf43b0b70608853ed4b511e285971675ef6a4fd9b0e"

  bottle do
    sha256 "967e57f7b87255ad9af901d2842110d5f7ec4c9a1e1d7937b6e2c2fd82aec289" => :high_sierra
    sha256 "e252bae440fb28bb0270c67997be929004bba9bd4668fe7a62dfe60fbf5bc6ac" => :sierra
    sha256 "852761add98282424a87e5e314473d86205284d429873054a1b29e4fb3b40608" => :el_capitan
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
