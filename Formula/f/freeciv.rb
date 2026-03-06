class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  license "GPL-2.0-or-later"
  head "https://github.com/freeciv/freeciv.git", branch: "main"

  stable do
    url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.3/freeciv-3.2.3.tar.xz"
    sha256 "989d6d58bd4cd97a4899e7e25afdee6c35fd03f87a379428a6e196d600d8d307"

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
    sha256 arm64_tahoe:   "3cbe6eaa8f40c6e4644eb1bb7d5af97f3425fd1f3378ff7d133c6673780c6e18"
    sha256 arm64_sequoia: "fd63a5fddf2683709aa2a2303827e79bdc6950744c854fa4d2159cd90bc19815"
    sha256 arm64_sonoma:  "e447325fce7a9bab451204a62204b8e783417b66ceeac2f3ad3a272789af1974"
    sha256 sonoma:        "f34c1a025f36b55ac16f1790b6f9e282c299a61bf4fc1f19cad9d55f16a8852f"
    sha256 arm64_linux:   "f926a11483072bd11599bfe1fead4d63a6a42955b217139f5d48e31b431ac468"
    sha256 x86_64_linux:  "9a114b68ec923737b713e617b4cc19c5ad25113ca27ccda5beb382dae48a1cae"
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
