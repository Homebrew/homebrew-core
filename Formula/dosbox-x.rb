class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.15.tar.gz"
  sha256 "60e196ee49e4532327d0786a9e3b4f1d28820906b0b868abecf89a19300fb3da"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "fa821e37147ed4c1760f39da2a2d7ea50bfe36941df4ccbf53b88fa762481ef4" => :mojave
    sha256 "c4e47a8bc4e6d8107b1c92d1135770a9cc50993b337d68d1f3225e01257d6ae0" => :high_sierra
    sha256 "364f2d423f0710fd050c6ce92fa641fd98b8fe4147e46e491a4f4aa93ea924d0" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fluid-synth"

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
