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
    cellar :any_skip_relocation
    rebuild 1
    sha256 "229bde3f399638b21570063c1586fce976f4498475901f28bce30546a4e60220" => :big_sur
    sha256 "02cd6e56f1a40d01069ee8d59ceafdab15e0c9ec6c75873f845f2588df87d31c" => :arm64_big_sur
    sha256 "c2aed2811e263c3e3abcf66eb27d6fdd1b622ca033fa2e3bf4e8095c733df08a" => :catalina
    sha256 "d2ba48c88116be774d989d71c791ef97f8eac3723e63a0924e08ea48f4b3ab39" => :mojave
    sha256 "d9408c8f70db105a621195339f357107d6f234c75be581b1ca8365d0e82e62c2" => :high_sierra
    sha256 "1319662888a509ceee3993bf17e7fb2f9dfaea5ce25c983c0bcda13283b5d612" => :sierra
    sha256 "def5b3fc8cef9b4c532cc26ae216d1c6b0dae54da5a39acbdb818d53a04bf697" => :el_capitan
    sha256 "8fedc8290fdcbd5cb5f8042cc83e4c10c6c2a29888c2a89f72280d3b5b53946d" => :yosemite
    sha256 "032a98149e12af8c223532b01aa74a2ab57ab3c1b5b6d3f0762d2cd2b51d62ee" => :mavericks
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
