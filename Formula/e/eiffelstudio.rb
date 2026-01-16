class Eiffelstudio < Formula
  desc "Development environment for the Eiffel language"
  homepage "https://www.eiffel.com"
  url "https://ftp.eiffel.com/pub/download/25.02/pp/PorterPackage_25.02_rev_98732.tar"
  version "25.02.98732"
  sha256 "fd7a1ec2a09e87535f077bdef542fed1665f6790c46b837b44497aec5b65c6dd"
  license "GPL-2.0-only"

  livecheck do
    url "https://ftp.eiffel.com/pub/download/latest/pp/"
    regex(/href=.*?PorterPackage[._-]v?(\d+(?:[._-]\d+|[._-]rev)+).t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].gsub("_rev_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f14da97c4684f2384c2d68dab556ea970b6191e8995634a31707e5a14bfb85a1"
    sha256 cellar: :any,                 arm64_sequoia: "4030c9fa5e0a839aae6c9f9f8b04af32d7f45c2203453ee51b23388444a74d67"
    sha256 cellar: :any,                 arm64_sonoma:  "ee29d34eabd019521717887b411c3a8edae4d29dbfd4c5d5cc20262df03dc6af"
    sha256 cellar: :any,                 arm64_ventura: "fedc736ae91c56ad1ff16d5dd21a0950ba47ed1dc51df977e20759348aa0e924"
    sha256 cellar: :any,                 sonoma:        "2b4450d781483aab1345f9453246ab778c820c208d910523c9918da5588aa0b7"
    sha256 cellar: :any,                 ventura:       "c630a8e2c1aa1857bfc26e40611293c855fa568285b17a1254ba13c8dcf1b162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90856df61aa3521fa22d999c3298cbe52f144c705927fee102798a3e2af7f3f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00230c658b6733ffde14178ef47d9919dbaf4694ebae211d938423068282aefb"
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
