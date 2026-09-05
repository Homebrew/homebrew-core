class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/freeciv/freeciv.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.6/freeciv-3.2.6.tar.xz"
    sha256 "b3ce15f54083b1fca146f62837a5f7d41d298537fa34940cca70eeb09c7a9c6e"

    # Backport support for Lua 5.5
    patch do
      url "https://github.com/freeciv/freeciv/commit/b427d038fab6c96983cef54cf618a4b07bd1a62f.patch?full_index=1"
      sha256 "4a0665180ff33e733809ec1185d484e6cc1dfed38ef7acd88f0f4e8042e5349f"
      type :backport
    end
    patch do
      url "https://github.com/freeciv/freeciv/commit/4718723428fc8009b7d46f9b6133d0fd76f056ab.patch?full_index=1"
      sha256 "5d5cb19715488f34c0bb40b3379609a48454353d0aa1967b9c58ccbbff502faa"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "7be9340d5ebbffcb1f17c4c36e68ccefc04938878d7d817d39af0a3515f0fff7"
    sha256 arm64_sequoia: "709df87f487030ce374381e87fbfce8190fb59729d0cb18ec16132bd8fdd9d1f"
    sha256 arm64_sonoma:  "49151c65b32eae9e15a7731d32c9ef7e1a4c957d03d2097bc3e3885caeb3f859"
    sha256 arm64_linux:   "e7c84f78d381f18e0f50b2c9406707405ea887612d6f795b8c6d5481caf659ad"
    sha256 x86_64_linux:  "67b2f95aa037eacf5618daba18916104f41f407f424f9fbee6ff169cb0dbd65b"
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
  depends_on "sdl2-compat"
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
