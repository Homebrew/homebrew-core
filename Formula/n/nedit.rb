class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.8.1-src.tar.gz"
  sha256 "17d4e3833c7066bea6be3ace5b1563d799a9eb48d8630c46d8bcefbaed49d74f"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "721a0a1a61e99e0ca60ef39522ee0c793a6efe07b8732b6e00eeb95c0b7e5aa4"
    sha256 cellar: :any, arm64_golden_gate: "bbc79c190c25002dc961691dc5d96224326c2ef57bdb6d3f174861b967cf01ea"
    sha256 cellar: :any, arm64_tahoe:       "47ace151655ef0f93cb34997782a66940747c649a23bd9029eea941f4f93cdba"
    sha256 cellar: :any, arm64_sequoia:     "ddbc911ffc162c5b889bf2f023eb2cea669004275d468a980d365e08755b4171"
    sha256 cellar: :any, arm64_linux:       "f7f3af92c979c1a1674f87d65457c578ab05d4c1a56fe1af82a91fc27233a558"
    sha256 cellar: :any, x86_64_linux:      "45ba7971a8bb50f935de56473febc9591603c2afc30fafa20b56ccff18f73802"
  end

  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "bison" => :build

  def install
    os = OS.mac? ? "macosx" : OS.kernel_name.downcase
    system "make", os, "MOTIFLINK='-lXm'"
    system "make", "-C", "doc", "man", "doc"

    bin.install "source/nedit"
    bin.install "source/nc" => "ncl"

    man1.install "doc/nedit.man" => "nedit.1x"
    man1.install "doc/nc.man" => "ncl.1x"
    (etc/"X11/app-defaults").install "doc/NEdit.ad" => "NEdit"
    doc.install Dir["doc/*"]
  end

  test do
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/nedit 2>&1", 1)
    assert_match "Can't open display", shell_output("DISPLAY= #{bin}/ncl 2>&1", 1)
  end
end
