class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "fa4f7cd1876e4b22e950b4ca7c90776eb8edcf137316bdfd9c1780cf7cfb5d73"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5a040aeefdda656584784bc9f1c46844777e5f4f034dd992499444ff16bbf042"
    sha256 arm64_monterey: "4c6c57dfee448421bc230cd81849d0f35edff5bcd9113b2648cb7616cd996252"
    sha256 arm64_big_sur:  "55f3d212cacd07402ccf80c92bafe68e92a7c7ff8bbbd2c14a0b0667b95ee93e"
    sha256 ventura:        "acb17776487b181834e3e2a97d05b46f9fd0231aca8f668e55ba5324e940d3a3"
    sha256 monterey:       "5c42be066184da56a10bc1f040c5d7fbf5dbeb48fecdd2a17d163da1d5dc68ce"
    sha256 big_sur:        "6b6e0696ab515d5350d7e576a63a0e5c1ee6440fcad7d4af2b79c18cda821329"
    sha256 x86_64_linux:   "7fa5a19f0a2d4c91054187be649f27bb81f211b50c74f9477e1ed3eff05145f8"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config",
                   "CC=#{ENV.cc}",
                   "YACC=#{Formula["bison"].opt_bin/"bison"}"

    bin.install "out/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
