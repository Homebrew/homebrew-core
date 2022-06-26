class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.84.0.tar.gz"
  sha256 "564fbf8f0ab090c8b32bc38637c8204358c386b9cbffcb4f99a81bc82fddbad7"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b1c66b44ffa6f942475c7d8a2d3e4ce093d49d8ed748268f55f6c71b38913cbd"
    sha256 cellar: :any, arm64_big_sur:  "c2b2ebcca8be7bd85024a2c54ba4c5a6c003a27c7de12231f77a0625e2c5bb1c"
    sha256 cellar: :any, monterey:       "a99a3ebfb082da87d164c495aee67bd84260a6141e21149ecb671d5e7673c084"
    sha256 cellar: :any, big_sur:        "bba10b3909c8703519bacf0563a1f5140b3b1f0ac649e9708ce0b37a77b994d9"
    sha256 cellar: :any, catalina:       "909a17f658c7f92a5e774a0ae911c3e00689295637b1a932b7c776b0c8e4691c"
    sha256               x86_64_linux:   "0a6f6e937a82baf7fbee8067ab11cfbb57d690a17785e25678a8ce9db7aa79c6"
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
