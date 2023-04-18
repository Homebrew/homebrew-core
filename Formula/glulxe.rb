class Glulxe < Formula
  desc "Portable VM like the Z-machine"
  homepage "https://www.eblong.com/zarf/glulx/"
  url "https://eblong.com/zarf/glulx/glulxe-060.tar.gz"
  version "0.6.0"
  sha256 "74880ecbe57130da67119388f29565fbc9198408cc100819fa602d7d82c746bb"
  license "MIT"
  head "https://github.com/erkyrath/glulxe.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a1428eb47dd0443e7d76127116828461087d9006810827318464138aae8f309"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26ce8c326d32c6a9bc677cb31ac3d71ad3c342b9268519ed852e3067073e020c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4685ff356d489470d50622a226708c1934221e100048759f2e63edb18c711964"
    sha256 cellar: :any_skip_relocation, ventura:        "728499b6faf39d716c538bf45b4fd63ec5a0702cbc08d4c9252a67967489228e"
    sha256 cellar: :any_skip_relocation, monterey:       "7a5f7a89d8fb4f97d8dd4c0e129c57750e716822f5a74d050f8d3e5012461710"
    sha256 cellar: :any_skip_relocation, big_sur:        "c147aa8b889f611ce1b8d1e7bdefc29c9b0da936fea7e187068039eb89255a0f"
    sha256 cellar: :any_skip_relocation, catalina:       "50f3bb35f8755b4c24989bc354d9fc81afc5c2442e6bb5250a9aa47541c0dff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d094a606fc180d36718be5f056934f832e7273be306e87813a190050181eedde"
  end

  depends_on "glktermw" => :build

  uses_from_macos "ncurses"

  def install
    glk = Formula["glktermw"]
    inreplace "Makefile", "GLKINCLUDEDIR = ../cheapglk", "GLKINCLUDEDIR = #{glk.include}"
    inreplace "Makefile", "GLKLIBDIR = ../cheapglk", "GLKLIBDIR = #{glk.lib}"
    inreplace "Makefile", "Make.cheapglk", "Make.#{glk.name}"

    system "make"
    bin.install "glulxe"
  end

  test do
    assert pipe_output("#{bin}/glulxe -v").start_with? "GlkTerm, library version"
  end
end
