class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.9.tar.gz"
  sha256 "cd62a0506262462f98ce8f79b8c771633fddd19d32dc568c0f073be1f451da0d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  livecheck do
    url :head
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "9091b416eecb265a586c69dc8ca40fec57468a4bbaa923b51a76de90003e4200" => :big_sur
    sha256 "6ab9a4668ed2098308b8ac158bcfb44cdf871ec3ba26ceb2e57c6e8905eb9f02" => :arm64_big_sur
    sha256 "ae1304d9342065c11f859ec4eed16f0dd28fc2182150477998252e9e1e825919" => :catalina
    sha256 "02d299d1de3491f8e0ef16ed25378ced95296d3bdd6e63a2214f2f15c48e2d86" => :mojave
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
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
