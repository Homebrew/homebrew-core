class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e226b4ff91e1260fc80e8312b39cde5a783b96e9f248530eae941b7f1bf6342a"
  license "GPL-3.0-only"
  head "https://github.com/ascii-boxes/boxes.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3ce2eb2156f5dc98a5e7213864e5c4d05d93ccd886a95a1e46a7be27f4b3d397"
    sha256 arm64_ventura:  "dd81b1f25a67a629079f560cea6cea0c55a59d3447777b3778efa1ed6e4b4ac0"
    sha256 arm64_monterey: "707ebb2d60f864d5b1a62b0fc0c9058089ad0f2f793a1b72eb4760457bb9486a"
    sha256 sonoma:         "0cb436916dd6325e63e8048c9da62be862a2d37d633148c41a4c0d911aa119e5"
    sha256 ventura:        "f7ad1f5e41055fabfbcd2ca4a4fc076e5f2d5aed1adca18743182f4031793092"
    sha256 monterey:       "65f45232b63581144335f9b424afb87846f03b0dd1988b2e727e2c4aa9086f6d"
    sha256 x86_64_linux:   "5d2a72f55f995ff6e998d73923a74b7cbe936a7832a15c1414f03172f9f08920"
  end

  depends_on "bison" => :build
  depends_on "libunistring"
  depends_on "pcre2"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

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
    assert_match "test brew", pipe_output(bin/"boxes", "test brew")
  end
end
