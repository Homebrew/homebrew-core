class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.3.tar.gz"
  sha256 "baa4c7f04415fbc2a99cfab6da4d33a7ca018d985fc71701c603a67c6b0a9426"

  bottle do
    sha256 "ec2167c01b3944ee32302786a82dd692f01175b81cb0720877fef9190495ab0c" => :sierra
    sha256 "941f6c4a5d9c5a653dd301338b0c70bdbd4995e820e252ea4e69352e58f8da3c" => :el_capitan
    sha256 "a32612204fc2399075446408c3efb7a442d7ea1097dd866500959052d1e22c9a" => :yosemite
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
