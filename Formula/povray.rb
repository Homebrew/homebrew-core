class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 5
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e604edf0b8a232c3b5f959246b00a20cbe4093016a0346a86062db7fd026d956"
    sha256 arm64_monterey: "478c125bd7219274fde373a995cb00ecfa0eae2be1a67c9d13481697402a394d"
    sha256 arm64_big_sur:  "95dac65a88c25e48ad0ac603d76b35ec249d1231f26db00cb486aeaecc5fb9cf"
    sha256 ventura:        "544ae2885610c66e016d4d402919257ec370d5241fcb5c9fbbeed28a1b873cdb"
    sha256 monterey:       "d8c1634230a4e5475487ff3991e2a624c5cc46b2c5d4e00f01397890f10a86b2"
    sha256 big_sur:        "116d6633f0fb3dbf06fd9f74da5ca096c09abe9a528b3e41eb68400417fc5fbb"
    sha256 x86_64_linux:   "f88347b3825ce19d79443d656beaae2f8a2db4ec3f0f35034e4b7c7e5ce6c1c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
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
