class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/atari800/atari800/releases/download/ATARI800_5_2_0/atari800-5.2.0-src.tgz"
    sha256 "3874d02b89d83c8089f75391a4c91ecb4e94001da2020c2617be088eba1f461f"
    depends_on "sdl12-compat"
  end

  livecheck do
    url :stable
    regex(/ATARI800[._-]v?(\d+(?:[._]\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e87acc86cd6e9fa170e8e29bf5c92e649b4af7de49faab2f25f4a573f655e380"
    sha256 cellar: :any,                 arm64_sequoia:  "82df74e82551f83d67d3a7fcba873d4bd62a0084bc96371fbcc16e760a80aac4"
    sha256 cellar: :any,                 arm64_sonoma:   "800ce7fc88004e578e5b69d573b4a3701245de0174fbd4a4494d37ad79c0f3d0"
    sha256 cellar: :any,                 arm64_ventura:  "07b1d045d2e043b5ffa9af66fa8680309ced19869b882783caa535a3895c85c5"
    sha256 cellar: :any,                 arm64_monterey: "fecd8f434681b731b644ca26c0f22d1be8373bce97386e0f7dd4eee0983ee29b"
    sha256 cellar: :any,                 sonoma:         "4053e4f8f91302c40fa30f31ee533ea3819e4e0ee736b328d4a9468f9846bd8d"
    sha256 cellar: :any,                 ventura:        "ab29186147fd355b806981cf9df942da3fe9a5c84041db411efa67662862283d"
    sha256 cellar: :any,                 monterey:       "2b2a241d5c0d1a9992682a0ff96fe9e7cec19ab3217deeb3839703779a35f2ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cdd1445eb9501d8495ebb18ee093636b15dc6b6490f2fa702c7a267eb3161440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656005889be7d36009a7b927d4b7437f38b988cc74063b5e3cefe3406bbffd77"
  end

  head do
    url "https://github.com/atari800/atari800.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "sdl2"
  end

  depends_on "libpng"

  uses_from_macos "zlib"

  on_linux do
    depends_on "readline"
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
