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
    sha256 "801fbc5c1f9a9379cf49966d1fc9202818acc6e80b351b258f22a42d3a3248da" => :big_sur
    sha256 "ca42769d75fa502b39bf51aa3338148a2df23562ccfb05a8c32c226d2ba9f793" => :arm64_big_sur
    sha256 "ccc8e783cc9043a1685ef7bbb596ff6f80ab4d952bdfcb4ecd590fd790b8f56f" => :catalina
    sha256 "fd3af9a91249a6f811371321db18005a2f98f8d984ff2a398064e3bb18be34f7" => :mojave
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
