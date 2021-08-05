class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.16.tar.gz"
  sha256 "327bb9be5f239407a0fe5ff501ce19d5056ac8b2ce2438fe60a9914952f08076"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "88ae82c2c3d037f26fc7ad7bef76514f9fe89f5d9e91b07dd56922f2d036bef1"
    sha256 cellar: :any, big_sur:       "83a55b85699f23b404c71b2aa4a5856da4bbe41b81f362fb026530bf6609d923"
    sha256 cellar: :any, catalina:      "911f560060b1baa477c8d4c04c1881e90b5e3aa961c3906a26872c0ac2501906"
    sha256 cellar: :any, mojave:        "115c0d5ba5977f4ee085b9566dcf7ea7db7e3b162cd06093939bb618fad1d21f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

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
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
