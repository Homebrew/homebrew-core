class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/v3.7.0.9.tar.gz"
  sha256 "c273f75864ac98f86b442f58597d842aa8b76e788ea5e9133724296d93fb3e6b"
  license "AGPL-3.0-or-later"
  head "https://github.com/POV-Ray/povray.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_big_sur: "f58475cad4e1bc129e831b586e8ad0ed7c504a46f758ad217895f78ff1a5778c"
    sha256 big_sur:       "06f7a322d371a831124fb970aacbd9310d0f1cfd478b7fe00d68b58e52d6ea7d"
    sha256 catalina:      "c79203e5cf7306333a3511a79b226815f9e406136e7f10ae8254db555faf238f"
    sha256 mojave:        "62ecf5b65b5581777dc7a7358846b36e39b75a99bd43f9927bbca393492cafeb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  # Check whether this can be switched to `openexr` at version bump
  # Issue ref: https://github.com/POV-Ray/povray/issues/408
  depends_on "openexr@2"

  def install
    ENV.cxx11

    args = %W[
      COMPILED_BY=homebrew
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr@2"].opt_prefix}
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
