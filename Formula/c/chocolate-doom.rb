class ChocolateDoom < Formula
  desc "Accurate source port of Doom"
  homepage "https://www.chocolate-doom.org/"
  url "https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-3.1.0.tar.gz"
  sha256 "f2c64843dcec312032b180c3b2f34b4cb26c4dcdaa7375a1601a3b1df11ef84d"
  license "GPL-2.0-only"
  head "https://github.com/chocolate-doom/chocolate-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^chocolate-doom[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "4f000383f25ecf073d230153d43208298586091496c89fffe550b1ac3ceec679"
    sha256 cellar: :any,                 arm64_sonoma:   "d48d6cab180c6b15c33208fb7147b3f60b8817d81d8cd3a02da366f84b04d9fe"
    sha256 cellar: :any,                 arm64_ventura:  "307ee7d5f7aac248e236f8235c0de58d303693d9767f62d981dbb2de2b6dbab6"
    sha256 cellar: :any,                 arm64_monterey: "3414e9cd11236891dfd66811b14a329b63b9ccf83f24f7564ddc589d170cf501"
    sha256 cellar: :any,                 sonoma:         "d0685590e292ca4f4901e523e5a1a2e77031e05da7cc21fd88ff1251bb10e981"
    sha256 cellar: :any,                 ventura:        "5722f18c1e6dfe86f4875ea77ca7c2e8cf70dc8e58ee8a4cfcdc6ad992c75b6f"
    sha256 cellar: :any,                 monterey:       "b47085bdb5cba8a81af6889d21fb725baba8108711428e708cbce4fa10bacacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d314bee173f047d52b928d7865e8d8fd10ef6635b34cc89a50259ab9766e2efc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install", "execgamesdir=#{bin}"
    rm_r(share/"applications")
    rm_r(share/"icons")
  end

  def caveats
    <<~EOS
      Note that this formula only installs a Doom game engine, and no
      actual levels. The original Doom levels are still under copyright,
      so you can copy them over and play them if you already own them.
      Otherwise, there are tons of free levels available online.
      Try starting here:
        #{homepage}
    EOS
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/chocolate-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
