class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/23.09/pp/PorterPackage_std_23.09_107341.tar"
  version "23.09.107341"
  sha256 "f92dad3226b81e695ba6deb752d7b8e84351f1dcab20e18492cc56a2b7d8d4b1"
  license "GPL-2.0-only"

  livecheck do
    url "https://ftp.eiffel.com/pub/download/latest/pp/"
    regex(/href=.*?PorterPackage[._-]std[._-]v?(\d+(?:[._-]\d+)+).t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("_-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c5655afc34eec519316fc5fb3f9c725cbcf50d0bf4827102548bda6387cd12d"
    sha256 cellar: :any,                 arm64_sonoma:  "0354eb4c3580064948257f7577b9c1a6de298148adcb599530973ab7fd546e71"
    sha256 cellar: :any,                 arm64_ventura: "24da4037b60feac74beae6588fc4dd998abda669233090597a7d283286b1ab4c"
    sha256 cellar: :any,                 sonoma:        "64e3fae2de6e0167f75255a50ce952182af971e1085261f08320a5497fc0f300"
    sha256 cellar: :any,                 ventura:       "268a946d64769df550f47f3446dd068db381666bbcf7614e82f6c53edfc6df71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea1bb6c9813e6f2b36b34f5046ed2893ae5ca1349903beefd648976c87f92883"
  end

  depends_on "pkg-config" => :build
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
      else
        # Use ENV.cc to link shared objects instead of directly invoking ld.
        # Reported upstream: https://support.eiffel.com/report_detail/19873.
        s.gsub! "sharedlink='ld'", "sharedlink='#{ENV.cc}'"
        s.gsub! "ldflags=\"-m elf_x86_64\"", "ldflags=''"
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
