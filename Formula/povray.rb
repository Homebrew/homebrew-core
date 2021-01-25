class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.8.tar.gz"
  sha256 "53d11ebd2972fc452af168a00eb83aefb61387662c10784e81b63e44aa575de4"
  license "AGPL-3.0-or-later"
  revision 1
  head "https://github.com/POV-Ray/povray.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    rebuild 2
    sha256 "11ca4524b9607133f05ec4a1bfc5068814c8f24c816457a15762068e0e53e108" => :big_sur
    sha256 "aa9bdecce6009e4bcf4c59c2d81c3b56aa0caa942e162dbe96e7440e9ee9b86e" => :arm64_big_sur
    sha256 "73110c4da834819acf4887efc1051cd0928e77cbaf773c76b891a92e28a68ac8" => :catalina
    sha256 "02725cdedd6abd1239284729cdf3fac874f81d302b1d23f3016c69724a24bde4" => :mojave
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

    # The VERSION file in the root of the package is read by the autoconf bits.
    # However, on a non-case-sensitive filesystem this breaks "#include <version>"
    # deep inside the boost libraries.  See https://github.com/POV-Ray/povray/issues/403
    rm "VERSION"
    rm "unix/VERSION"
    rm "libraries/tiff/VERSION"

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
