class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "http://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.82.15.tar.gz"
  sha256 "60e196ee49e4532327d0786a9e3b4f1d28820906b0b868abecf89a19300fb3da"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "3082c131a38cc73d4ed8a5e06d9251bbb23a3b4bbad16da4653b5927f83c256f" => :mojave
    sha256 "9fc51a3c234fdc91214ddc29ebccc38560304bcae869db8d4fe884a2af5e3f2a" => :high_sierra
    sha256 "d9957978778bc92cee3693f813b8f03f5a12f33ee6f80912fa0cce759e4f5023" => :sierra
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
