class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "http://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.7.tar.gz"
  sha256 "085746e891edbb2cfda22bb2a8b86043bd680a68ad9121bc568118c730ace7b9"

  bottle do
    sha256 "35f5427c7f206b4964e0d0fbf76bd03f3796b0afc8622790f962c318c92fb298" => :high_sierra
    sha256 "c0ceb17e9bf1f3de0cc9d66ef5e1142fc725d1a09e415a13fdba8e06b428535f" => :sierra
    sha256 "cb34de2b4310b67342fddf0aebfa48f03eadc5c7f4c653fa64139241fdf1da71" => :el_capitan
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
