class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 12
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "3814912ad793bb6f99aaec46a5b69a7365a07a4f7a776d6aee1573ecfd69efca"
    sha256 arm64_sonoma:   "5cf35722079d7dd1d6f4f0829ae3cd625a4e9a1e43507fd0c8d8ad73f85ba5d7"
    sha256 arm64_ventura:  "dfb40a725c12450107ae31a44a361e7b6e7b0a709bd4b53ee2f334b49d21dd3f"
    sha256 arm64_monterey: "9e8e0917cce94395ae979af1eb47e3a657693fec4574e0b7195eb5bc31d7ecff"
    sha256 sonoma:         "2eae82eac7281c82ac56a5df270f64801bb43d9cfce6ffecfcf34fe6cefeaeea"
    sha256 ventura:        "8549b9706027eff9ac82d004592ee2b90bfd3a0033493455b2c4e39cfbf2fca1"
    sha256 monterey:       "a8c775e06b2740fbf07fcc153a5b910429b71fa992907351d33e34b420162c86"
    sha256 x86_64_linux:   "f88d3ae2c4a40f22fe92f18b9caff59887a9ac660f93c979b826931775e74b45"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  uses_from_macos "zlib"

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
