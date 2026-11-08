class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  license "AGPL-3.0-or-later"
  revision 17

  stable do
    url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
    sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"

    depends_on "boost"

    on_sequoia :or_newer do
      # Apply FreeBSD patches for libc++ >= 19 needed in Xcode 16.3
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfe.cpp"
        sha256 "81e6ad64dadce1581cbab3be9774d5a5c22307e8738ee1452eb7e4d3e5a7e234"
        type :unofficial
      end
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfeconf.h"
        sha256 "8e2246c5ded770b0fe835ae062aca44e98fc220314e39ba6c068ed7f270b71b2"
        type :unofficial
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "4c13b09ae94c57eea35c4701e14cfa20a13b32ef7166bf6802baeca3488ef3d7"
    sha256 arm64_tahoe:       "102f3c00d65ef6e00504bf3908a5e3b97b27115d81603604cca63cacffd5c378"
    sha256 arm64_sequoia:     "09518f6266b1e616c411f4bdee1955a5b9847a09a51ae11f8d0f41a1222030ff"
    sha256 arm64_linux:       "94529c9518243bdf75b7e05ec67c69f0c0ddf4a0379b3b3d1a53ff8954514156"
    sha256 x86_64_linux:      "211aac4d0069aa8e509a4cb8908dd07cf6b33a284369aba6d017c47f25561ea8"
  end

  head do
    url "https://github.com/POV-Ray/povray.git", branch: "master"

    depends_on "boost" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openexr"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV.cxx11
    # See https://github.com/freebsd/freebsd-ports/commit/6133473e4227abbfcf023bea6ab5eeed9c17e55b
    if build.stable? && OS.mac? && MacOS.version >= :sequoia
      ENV.append "CPPFLAGS", "-DPOVMSUCS2=char16_t -DUCS2=char16_t -DUCS4=char32_t"
    end

    # Workaround for Xcode 16.3+, issue ref: https://github.com/POV-Ray/povray/issues/479
    inreplace "source/#{build.stable? ? "backend" : "core"}/shape/truetype.cpp",
              "#if !defined(TARGET_OS_MAC)",
              "#if !defined(__MACTYPES__)"

    # Remove bundled libraries
    rm_r("libraries")

    # Disable optimizations similar to Debian/Fedora. This mainly removes `-ffast-math`
    # as `povray` has open bugs like https://github.com/POV-Ray/povray/issues/460.
    # Other optimizations like `-O3` and `-march=native` were always removed by brew.
    args = %W[
      COMPILED_BY=#{tap&.user || "Homebrew"}
      --disable-optimiz
      --mandir=#{man}
      --with-boost=#{formula_opt_prefix("boost")}
      --with-openexr=#{formula_opt_prefix("openexr")}
      --without-libsdl
      --without-x
    ]

    # Adjust some scripts to search for `etc` in HOMEBREW_PREFIX.
    %w[allanim allscene portfolio].each do |script|
      inreplace "unix/scripts/#{script}.sh", /^DEFAULT_DIR=.*$/, "DEFAULT_DIR=#{HOMEBREW_PREFIX}"
    end

    cd "unix" do
      system "./prebuild.sh"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    # Render variants of the famous Utah teapot as a quick smoke test
    sampledir = share/"povray-#{version.major_minor}"
    scenes = sampledir.glob("scenes/advanced/teapot/*.pov")
    refute_empty scenes, "Failed to find test scenes."

    # Also render a sample without viewing angle set
    scenes << (sampledir/"scenes/advanced/chess2.pov")

    scenes.each do |scene|
      system sampledir/"scripts/render_scene.sh", ".", scene
    end
  end
end
