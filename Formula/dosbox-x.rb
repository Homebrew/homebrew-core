class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.21.tar.gz"
  sha256 "2b5ddf9fc86bd6ff55b3bfdc2984c87698939583e9f8956d552ae922eb4fcb3d"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "af7f527be49f3547484915474cc31619122fc8d5ec3c6c212d579df4bb1dc235" => :mojave
    sha256 "1e586820dfdb67d163c46df2833539e8128f131106082bb7fc9f1c2a0789c336" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
    assert_match /DOSBox version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
