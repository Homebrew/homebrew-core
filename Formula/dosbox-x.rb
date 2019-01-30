class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.14.tar.gz"
  sha256 "eda33f10a369fe81d5a4bc6250ca97d3b707cc45e79be66ccfa410174ba77aef"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "16010137841ad1a80bd7994f94013087339c2b3edf8c842ab7906872531e1a3e" => :mojave
    sha256 "0b3459029756df719fa4a4bf87b45c878df887622be43436ceb30a3e7d29390a" => :high_sierra
    sha256 "cde277ce3239bd99c0d177491bd973dd6f81ec1a34c8f7ddd75c4c57da20d410" => :sierra
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
