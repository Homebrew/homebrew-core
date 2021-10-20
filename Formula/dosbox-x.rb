class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.18.tar.gz"
  sha256 "e80d5ad8f79c28422207bba676bc3524c1f94c4df9587cb33d28eb2e8e3792df"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3c585a4e26c112f5a46dc412a8b073a0e46072fb1c6dd4abdfd647ce59954027"
    sha256 cellar: :any, big_sur:       "67c16eb7d01f0cfa13d859f095d6441c4c98aa70b0318b81650cd3e355fc9539"
    sha256 cellar: :any, catalina:      "fc27bbdb6a6a76907062ccd3ddb25ab520b5aeb3d57f45b299210bf6b51b261b"
    sha256 cellar: :any, mojave:        "d5df91e8cacd5c9b40c0b6b7e0d324a4103d51084005cabc24009273db6f1072"
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
