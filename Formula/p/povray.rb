class Povray < Formula
  desc "Persistence Of Vision RAYtracer (POVRAY)"
  homepage "https://www.povray.org/"
  license "AGPL-3.0-or-later"
  revision 15

  stable do
    url "https://github.com/POV-Ray/povray/archive/refs/tags/v3.7.0.10.tar.gz"
    sha256 "7bee83d9296b98b7956eb94210cf30aa5c1bbeada8ef6b93bb52228bbc83abff"

    depends_on "boost"

    on_sequoia :or_newer do
      # Apply FreeBSD patches for libc++ >= 19 needed in Xcode 16.3
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfe.cpp"
        sha256 "81e6ad64dadce1581cbab3be9774d5a5c22307e8738ee1452eb7e4d3e5a7e234"
      end
      patch :p0 do
        url "https://raw.githubusercontent.com/freebsd/freebsd-ports/6133473e4227abbfcf023bea6ab5eeed9c17e55b/graphics/povray37/files/patch-vfe_vfeconf.h"
        sha256 "8e2246c5ded770b0fe835ae062aca44e98fc220314e39ba6c068ed7f270b71b2"
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+\.\d{1,4})$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "55cd4d67cca78d36e98a6997489de220f80403bac07a1747732cdf5c5649ad56"
    sha256 arm64_sequoia: "033dfeea0176978972432eebf5abd073c33e651586850659a991191363b49a74"
    sha256 arm64_sonoma:  "40b763e62c00a88dbd0bd01812fe056ebbde2bf93fe346aaa21a0e4db7ebba0f"
    sha256 sonoma:        "30f0919619a000450453ce8c07f58e421f2e12f8754d6ebc7c34768d61ac24db"
    sha256 arm64_linux:   "77375757a81bcdd67b267983256491b369a57803df9cd79438a1c48dfee3c204"
    sha256 x86_64_linux:  "00fdfd84a3e3258f024cd77a80696966cb4b5d57f74bdbe029f913831c92a2de"
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
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-openexr=#{Formula["openexr"].opt_prefix}
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
