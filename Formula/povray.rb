class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.8.tar.gz"
  sha256 "53d11ebd2972fc452af168a00eb83aefb61387662c10784e81b63e44aa575de4"
  revision 1

  bottle do
    rebuild 1
    sha256 "a882f103b0ad016cbafa13cc1fd028046b337590feff3e6188bb574f1e328488" => :catalina
    sha256 "eae4cf975215cdfdeadb665c53061c6ed2b4f9fa95121e7145222409b0e44c56" => :mojave
    sha256 "4472bb00380eb26d3045dd5e67effa4f75934936263129009f9a80bbf5290633" => :high_sierra
    sha256 "f21cb29c30c8367aa14f6a4485bf03377f23e30b2e7178be466d12bb84be26a9" => :sierra
    sha256 "f2f0bf20fbe2d5b1ce91ecdf4eca52e4a544323910febae396d8b9fb1c0044ec" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  depends_on "openexr"

  def install
    ENV.cxx11

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr"].opt_prefix}
      --without-libsdl
      --without-x
    ]

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
