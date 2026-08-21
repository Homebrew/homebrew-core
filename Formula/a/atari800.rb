class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_7_1_2/atari800-7.1.2-src.tgz"
  sha256 "9602badfd7c45551cb5c4cc77f862af377c43a07caaa0bfc77ac87f9179673e3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ead342a44a99702268f6ac063affae6865e23dbb958c5816bbd36d74bd7a5b76"
    sha256 cellar: :any, arm64_sequoia: "b4b5a4e801826dd486726a8ad2475115c3ebfdda8aad73bbb04fc2dd68c92a4b"
    sha256 cellar: :any, arm64_sonoma:  "8a729644bf33cb139b3ba9b5402e9f7501784ffc3e6b9bba9f5a2c71700b1abc"
    sha256 cellar: :any, sonoma:        "01da96e221060afbb1f74ce602208bc83a73653f287044b3cd1674028f3b24ff"
    sha256 cellar: :any, arm64_linux:   "3ee1fbff7fa7788a73771565abf5e56632817bf0b9be2312ecd0183b94a656f8"
    sha256 cellar: :any, x86_64_linux:  "36fa5a1669964012f938dbad4b4e4172376b38139ea2e74d9b428042f7fa125c"
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
