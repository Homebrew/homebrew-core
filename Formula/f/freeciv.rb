class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/freeciv/freeciv.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.4/freeciv-3.2.4.tar.xz"
    sha256 "e0a19508bf69dc4fb7c251d391253794d772bfcce2dbd30fa453521244edd32c"

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/freeciv/freeciv/commit/b427d038fab6c96983cef54cf618a4b07bd1a62f.patch?full_index=1"
      sha256 "4a0665180ff33e733809ec1185d484e6cc1dfed38ef7acd88f0f4e8042e5349f"
    end
    patch do
      url "https://github.com/freeciv/freeciv/commit/4718723428fc8009b7d46f9b6133d0fd76f056ab.patch?full_index=1"
      sha256 "5d5cb19715488f34c0bb40b3379609a48454353d0aa1967b9c58ccbbff502faa"
    end
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "109cfd1ecf6d7b7a583e63adcf244196d5b11fc1be132bef50c51d4a69f07453"
    sha256 arm64_sequoia: "530b2aa5b7880af861e5e17d4ab95ce0980e26cc7cf27f88ebe51d9dea34d8e9"
    sha256 arm64_sonoma:  "dbec237b1ed34f256535f8e45f2dc858b626a92d7c8a82972a90d650ecaab4f4"
    sha256 sonoma:        "da78add7aeb770b21dc4e52682b281963a01cf8a324d15703db5cd1f852f6f8b"
    sha256 arm64_linux:   "319677b0a829fb1aad86babc3ae3175ca0996d08a42ad5ae370cddcf08d0c26e"
    sha256 x86_64_linux:  "8f2bf88e394e20849d65b6b5283b4d3661b7ccf3b7faa00ad8598f1862d52771"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "icu4c@78"
  depends_on "lua"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}" if OS.mac?

    # Remove bundled lua
    lua = Formula["lua"]
    rm_r(Dir["dependencies/lua-*"])
    mkpath "dependencies/lua-#{lua.version.major_minor}/src"
    ENV.append_to_cflags "-I#{lua.opt_include}/lua"

    # ruledit removed from tools as needs Qt
    args = %w[
      -Dreadline=true
      -Dsyslua=true
      -Dtools=manual,ruleup
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"freeciv-manual"
    %w[
      civ2civ31.html
      civ2civ32.html
      civ2civ33.html
      civ2civ34.html
      civ2civ35.html
      civ2civ36.html
      civ2civ37.html
      civ2civ38.html
    ].each do |file|
      assert_path_exists testpath/file
    end

    spawn bin/"freeciv-server", "-l", testpath/"test.log"
    sleep 5
    assert_path_exists testpath/"test.log"
  end
end
