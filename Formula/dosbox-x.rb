class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.21.tar.gz"
  sha256 "2b5ddf9fc86bd6ff55b3bfdc2984c87698939583e9f8956d552ae922eb4fcb3d"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ced2bf248a9734542381e95eda61ba655bbd8dccba563dd4b6d6926bf06e9d8b" => :mojave
    sha256 "a30f925eed238cef0f7280255f951c8676941d7ef7d9c14f101e084b02f1215d" => :high_sierra
    sha256 "0b1742988a8b1f2676d8ce39079366c57231e7bab0a1a92de32023e3d56d063a" => :sierra
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
