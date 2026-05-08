class Nedit < Formula
  desc "Fast, compact Motif/X11 plain text editor"
  homepage "https://sourceforge.net/projects/nedit/"
  url "https://downloads.sourceforge.net/project/nedit/nedit-source/nedit-5.8-src.tar.gz"
  sha256 "5851aa7252dad952084529173640232562dec4a7c440209f196d53d4a5a8074d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "57c0e5d9d4030379c66950917aaeb74062f7f0885699a90b126831122f39abc8"
    sha256 cellar: :any,                 arm64_sequoia: "0e75d477419cb59869db55d119950d0393d22095a273907129516479f532cd62"
    sha256 cellar: :any,                 arm64_sonoma:  "5bbce265406dc2d015e3066dbec0a7f5fef015d023a38d15e28d1727e2a4275b"
    sha256 cellar: :any,                 sonoma:        "d188ea82ea9ef84466ed111ad35e1bd9d211bea3595811e409434397b7f56cec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a4f184b41db7d158674ecef8ce97e22bac2301fe87a79e2ab46bb0722f89a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05af0a4e7d2f76dc8ea329cadea6f018524fffd06668a1e0c882f6ae0d3ad97"
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
