class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.25.tar.gz"
  sha256 "f9691acf81f953371a166b1ccc9c8b3e58b984216f0145edf2d6f5a05e794ede"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "fd1cf9ca70db1535c6cc3c018e074a53305dc0dd51070b98bc3fe2cfe7b81dbd"
    sha256 cellar: :any, arm64_big_sur:  "02988e38490d6a9ad7488aa8753eeed6c9247bf50f08c264843c9749bb73905f"
    sha256 cellar: :any, monterey:       "9baf2920ec2e05e99d5f9018b660262408de217dbb231e2522637cbbf1813fe2"
    sha256 cellar: :any, big_sur:        "761b281fc35751a35c57b01eb1848361913a3fdb9f9afd1c425a2edc9af24c10"
    sha256 cellar: :any, catalina:       "c8e0d54dca592dcdccb32b8ad5cce73023d649a06eb68a1ba7dc18ffc2a268d0"
    sha256               x86_64_linux:   "f61fc1fffca026ccbac0827be97fa01a8621596a0a76f4944cd0305dbcefa234"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  on_linux do
    depends_on "linux-headers@4.15" => :build
    depends_on "gcc"
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    build_script = OS.mac? ? "./build-macosx" : "./build"
    system build_script, *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
