class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/freeciv/freeciv.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.7/freeciv-3.2.7.tar.xz"
    sha256 "2720076d50f29db42cdc5e510e7c098f7793f7c0ac410fdf390a52bc57507917"

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
    sha256 arm64_golden_gate: "55a6b9a129dbd02541eebc97c2c756bee277da597a89ad55dc4160a1b363ec5f"
    sha256 arm64_tahoe:       "4fd1bd5686ac72f798a202b81535440e7cd75e76fe63ee8c4190c8ce0c2be15c"
    sha256 arm64_sequoia:     "28d9b6dbf5405a6b0ee7c5b119c14356da94055cf417d463e75b47a3e65f81e8"
    sha256 arm64_linux:       "551ce01c721324c066d360c5b0792bba649fed5d73c6c188d04a60fbfe02e281"
    sha256 x86_64_linux:      "f28819b1a0ed582a5294f9bff80fe629e0caf37579936bec28ae61d64174803c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "icu4c@79"
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
