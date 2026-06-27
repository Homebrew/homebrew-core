class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_6_1_0/atari800-6.1.0-src.tgz"
  sha256 "b76bba5ef84bfb1415e9cc2e83d8e2057f14cbbad5addb22cbefb5490171702a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^ATARI800[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b8b87e87dd1d0c148c50c4532d9ad91de250bb123fb079bbcc3da49dec13c273"
    sha256 cellar: :any, arm64_sequoia: "3b144b341ebbef7b42c85d7aeaf4152be6e79860703769ccd829fbadf96ec461"
    sha256 cellar: :any, arm64_sonoma:  "6611eee43379193d40d31526694fd4b08e9726dec00df6085fc6ed3aaa75107e"
    sha256 cellar: :any, sonoma:        "0c74611be1bb66411e2356ca5c6505b12ac4cab042d01db732dbdd7c923ca4fe"
    sha256 cellar: :any, arm64_linux:   "20931e4c9e7b57d6a7a39ef8ff59ee0bf048c47d89296f96ba22eba82c0020c8"
    sha256 cellar: :any, x86_64_linux:  "32cacaf8b4a0d1186ded4a0da1996ed5f56883ea42c7f88a5a6f5115b3b4d83d"
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
