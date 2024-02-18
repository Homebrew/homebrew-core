class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
  sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"
  license "AGPL-3.0-or-later"
  revision 9
  head "https://github.com/POV-Ray/povray.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "58c3ac588443f1be1b90ac3a717deda6a1b8f53935e654c0120dce777f6db80f"
    sha256 arm64_ventura:  "9e8f03294d5464c2dbc355bea10c397c02b653f52a7d67fee4f68815cb9d2199"
    sha256 arm64_monterey: "3d2230cc3042881a08dcf670e5374843329a23919df5cd569b8dc38cda48e3a7"
    sha256 sonoma:         "7932e7afc0a9687e4e109a74fea8c0a8a764518624576c75551d97efd5dc940e"
    sha256 ventura:        "13483635b9319cc17db576cbb27c03ee54941c2605fcf5b91f48b90927b39527"
    sha256 monterey:       "03063a44389c96958050725ebc67ff79b99909825615723cad0fe3c7390766a5"
    sha256 x86_64_linux:   "df7d086ede596888cfd1c4ca97e60383befd4204125713d90142033e4a78ed32"
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
