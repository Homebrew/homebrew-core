class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.3.tar.gz"
  sha256 "48f005949ada1ace8ad8c00bb27fad17d566e5bcdbec8be6078e44f8ad04759a"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "188b8c6fea8b9b0a48f9954b5880b5930e5f5a60676ed00b6e737299af0a247e" => :catalina
    sha256 "a79924c841eb8e32af442c35f2a473261cdbccd69cfed0a0a43cda5871aa76e3" => :mojave
    sha256 "fcd0e2800565054884857b256096cfd650fb64b7a004bfbc60a5e934f1daa8af" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on :macos => :high_sierra # needs futimens

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
