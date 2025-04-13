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
    sha256 cellar: :any,                 arm64_sequoia: "f53fe709078a0b99df505467ce2ed36139b7bb692e76b51cb66d3c177eb81c1f"
    sha256 cellar: :any,                 arm64_sonoma:  "756ba74eb55015c9a862e66c71e30b044df6ed6387e4c75804b04f17abe0c565"
    sha256 cellar: :any,                 arm64_ventura: "edd61003eaccc9f0f98dc887c6446520eac6e5a2201cffb1467cc360f836f0d6"
    sha256 cellar: :any,                 sonoma:        "ca47472f6ff1d99d2a6f625c8fc29056b5cfba9f01fa967582da0afe6af634a0"
    sha256 cellar: :any,                 ventura:       "962dd821c1033fccab1662fac98c08d85c784bb249ee892c98ab424ba59e11fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5fd1e711755deb0a35163544904e0bc01ac0e03c183527541419d3af39d4d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08f320ba178cd2a918863d1dbb9bf44a1e9b5ae4c5e0b269c6f2377d17e9d961"
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
    platform = "#{OS.mac? ? "macosx" : OS.kernel_name.downcase}-x86-64"

    # Apply workarounds
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500
    system "tar", "xf", "c.tar.bz2"
    inreplace "C/CONFIGS/#{platform}" do |s|
      if OS.mac?
        # Fix flat namespace usage in C shared library.
        s.gsub! "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
      end
    end
    system "tar", "cjf", "c.tar.bz2", "C"

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
