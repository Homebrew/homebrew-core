class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_monterey: "4078f9e9ed5cd96b6859a0d1e225d77146cfb59acfca9b0f6d10557dfeb61b76"
    sha256 arm64_big_sur:  "1d34756f9ee836d1d61acfc5650c5244afe44972cd3e2eb234b023b8af8fb4e6"
    sha256 monterey:       "a71fca973525b23fcf02a8ea1b328657ec7dd0bff50abcbfba8c1b3d948fb0c4"
    sha256 big_sur:        "8255395098744449c44cc26a30167fe767de560f202687cd4c089d4d926b8207"
    sha256 catalina:       "04feb4dafdf3f36c668c5444e8b6fcb8253819afed158eab35f4ef26e27ef229"
    sha256 mojave:         "bcdbae6ca75a38c84eef048ec9ca494d75d8b67f2abb054f31acf0e75dc84edc"
    sha256 x86_64_linux:   "fbf5db051d3e55ab7e213e313167a539113595fcd214919f358f32c7a8c50b95"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
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
