class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_7_0_0/atari800-7.0.0-src.tgz"
  sha256 "d2cf51d6e529dbf0d1fb1be4f838ee67582d3ce9719f3a362eee3093835d3438"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61293e3b473d10aca7cb86f8567a5478cea1565e5ad23ae691f608c3ee3923f9"
    sha256 cellar: :any, arm64_sequoia: "03e013679bd8f595eb723e0e1ab991d6dcb405051ea18f7c61c1964fe6a09224"
    sha256 cellar: :any, arm64_sonoma:  "a5bef435426858ea6f6868dab2da11815492d2adf156a20f23619044d17d77d8"
    sha256 cellar: :any, sonoma:        "164fe02c9186448f843908839a5ea1f245db0b8e80cd6ab26dec2b7ee7326491"
    sha256 cellar: :any, arm64_linux:   "f9ed87c2db0affa28599fbdff849e793bb63d9a1c7d64e50cc1b52200ea6b82b"
    sha256 cellar: :any, x86_64_linux:  "6f6191105efe63256b19e67863b9e0a64ea969ae4585fd92a3a99c895fe8dfcb"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "sdl2-compat"

  on_linux do
    depends_on "readline"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-sdltest",
                          "--disable-riodevice",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
