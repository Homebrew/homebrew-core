class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/24.05/pp/PorterPackage_24.05_rev_107822.tar"
  version "24.05.107822"
  sha256 "ca3f2f428568eea7823a1a8bd0d66713b5cadb051cada956a0d3b85a0022621c"
  license "GPL-2.0-only"

  livecheck do
    url "https://ftp.eiffel.com/pub/download/latest/pp/"
    regex(/href=.*?PorterPackage[._-]std[._-]v?(\d+(?:[._-]\d+)+).t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_-", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "439bf0adf57faebf0897400e531338efeb4e91e7b9a4470ba94932d3025d3cbb"
    sha256 cellar: :any,                 arm64_sonoma:  "b42e40979b8e31a2ed84a32b024811b5d50aa97bca7c96ab53300e6de45c7bbb"
    sha256 cellar: :any,                 arm64_ventura: "1f31d3cd0b9dbfe91cfacda4bced48918f29a6d861f23fe764d3f4d9333ab4cb"
    sha256 cellar: :any,                 sonoma:        "88bf14ac5fd6270aef08d59b7e74d2d2650a56f2022b07d884901c62db9d7fe1"
    sha256 cellar: :any,                 ventura:       "0f1a0494b436a30d3cb01c7b982be6e3770200fc3e70badb0c9ab94fcd4e6368"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "319253cc55f63693b4d879ef4b37ef84a80af596d2fe7eb6b9ed6adcb5ddef7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d47f2c53bb4b1ac77df03ba2504fdd788d10973bce17d2e5be256184b99bbed"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libx11"
  depends_on "pango"

  uses_from_macos "pax" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    platform = if OS.mac?
      "macosx-x86-64"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch.to_s.tr("_", "-")}"
    end

    # Apply workarounds
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    if OS.mac?
      system "tar", "xf", "c.tar.bz2"
      # Fix flat namespace usage in C shared library.
      inreplace "C/CONFIGS/#{platform}", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      system "tar", "cjf", "c.tar.bz2", "C"
    end

    system "./compile_exes", platform
    system "./make_images", platform
    prefix.install (buildpath/"Eiffel_#{version.to_s[/^(\d+\.\d+)/, 1]}").children

    eiffel_env = { ISE_EIFFEL: prefix, ISE_PLATFORM: platform }
    {
      studio:       %w[ec ecb estudio finish_freezing],
      tools:        %w[compile_all iron syntax_updater],
      vision2_demo: %w[vision2_demo],
    }.each do |subdir, targets|
      targets.each do |target|
        (bin/target).write_env_script prefix/subdir.to_s/"spec"/platform/"bin"/target, eiffel_env
      end
    end
  end

  test do
    # More extensive testing requires the full test suite
    # which is not part of this package.
    system bin/"ec", "-version"
  end
end
