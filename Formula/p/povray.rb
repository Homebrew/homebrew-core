class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  license "AGPL-3.0-or-later"
  revision 16

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
    sha256 arm64_tahoe:   "848f9ea4cc007231c5887b52daade272eeda7eb16f1f621657fcbdfdc9876790"
    sha256 arm64_sequoia: "0dc49f4371c081f8e07bc6e65e38af465a59f842831c16afc5eac801328092ba"
    sha256 arm64_sonoma:  "5acf3438e52e2d6194d259d612b7bc62a7fd51da865a4b3d98e56668b2bc6d56"
    sha256 sonoma:        "d9cd48308ca13736b0ebbf1e37c9b33af82f26e3d6c18b9e536afb8c3cd141ea"
    sha256 arm64_linux:   "afe3c68e4988994ec185fea805a33f67af19f46e4efcc91370b5e37d673d07cb"
    sha256 x86_64_linux:  "76dbcf106945d30b13f99d6880a549c2cf67646e6d5f7558520a3527aeae1135"
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
