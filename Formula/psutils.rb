class Psutils < Formula
  desc "Collection of PostScript document handling utilities"
  homepage "http://knackered.org/angus/psutils/"
  url "ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz"
  version "p17"
  sha256 "3853eb79584ba8fbe27a815425b65a9f7f15b258e0d43a05a856bdb75d588ae4"
  license "psutils"

  # This regex is open-ended (i.e., it doesn't contain a trailing delimiter like
  # `\.t`), since the homepage only links to an unversioned archive file
  # (`psutils.tar.gz`) or a versioned archive file with additional trailing text
  # (`psutils-p17-a4-nt.zip`). Relying on the trailing text of the versioned
  # archive file remaining the same could make this check liable to break, so
  # we'll simply leave it looser until/unless it causes a problem.
  livecheck do
    url :homepage
    regex(/href=.*?psutils[._-](p\d+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d31594cd841f9c3fab5b2d57b7562f27614e91b88c0021f2d6132d4100f3133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02cd6e56f1a40d01069ee8d59ceafdab15e0c9ec6c75873f845f2588df87d31c"
    sha256 cellar: :any_skip_relocation, monterey:       "5531ac88d24275129272f8e0c14f185ff06cd114f4c530624d1d436bd4e4df54"
    sha256 cellar: :any_skip_relocation, big_sur:        "229bde3f399638b21570063c1586fce976f4498475901f28bce30546a4e60220"
    sha256 cellar: :any_skip_relocation, catalina:       "c2aed2811e263c3e3abcf66eb27d6fdd1b622ca033fa2e3bf4e8095c733df08a"
    sha256 cellar: :any_skip_relocation, mojave:         "d2ba48c88116be774d989d71c791ef97f8eac3723e63a0924e08ea48f4b3ab39"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d9408c8f70db105a621195339f357107d6f234c75be581b1ca8365d0e82e62c2"
    sha256 cellar: :any_skip_relocation, sierra:         "1319662888a509ceee3993bf17e7fb2f9dfaea5ce25c983c0bcda13283b5d612"
    sha256 cellar: :any_skip_relocation, el_capitan:     "def5b3fc8cef9b4c532cc26ae216d1c6b0dae54da5a39acbdb818d53a04bf697"
    sha256 cellar: :any_skip_relocation, yosemite:       "8fedc8290fdcbd5cb5f8042cc83e4c10c6c2a29888c2a89f72280d3b5b53946d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3596c25429993fbcfa470fae16bafaa3da785fb610cacf9063d2b8ee26300d42"
  end

  def install
    # This is required, because the makefile expects that its man folder exists
    man1.mkpath
    system "make", "-f", "Makefile.unix",
                         "PERL=/usr/bin/perl",
                         "BINDIR=#{bin}",
                         "INCLUDEDIR=#{pkgshare}",
                         "MANDIR=#{man1}",
                         "install"
  end

  test do
    system "sh", "-c", "#{bin}/showchar Palatino B > test.ps"
    system "#{bin}/psmerge", "-omulti.ps", "test.ps", "test.ps",
      "test.ps", "test.ps"
    system "#{bin}/psnup", "-n", "2", "multi.ps", "nup.ps"
    system "#{bin}/psselect", "-p1", "multi.ps", "test2.ps"
  end
end
