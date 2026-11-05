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
    sha256 arm64_golden_gate: "23add6a497ac8e9f22db314e622eead2899cf7c0aa8545103b9328bf498a94a5"
    sha256 arm64_tahoe:       "3bf3f47bd721c6016056385f42eb081e7e25c3d48a23a2fd1aed7cf6f8f03f64"
    sha256 arm64_sequoia:     "f28fe448562920102cdd043c55ae6584e383c2dcd94304c4cbca1f8850f95bd2"
    sha256 arm64_linux:       "e37d66ca4f4babc3c2aed8284ac289c244a9ba7817465f53ff6fdd9884128213"
    sha256 x86_64_linux:      "3cf6366672e9284816b1e407c9960a17c9478c29c95c1e4502a626804d055662"
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
