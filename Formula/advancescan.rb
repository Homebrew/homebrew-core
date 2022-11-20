class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac972445b713681140e05905b842621e3d5e845f4a697686f7d9d5578eb9a53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f031fe7a7fcb2f3184a2b5e07339d6b400c3d776d43f6b1a1a62bdaaf49eed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edf3274971a23adffeca610c2ec178698fea761c728f6b92a6610da67695dcbf"
    sha256 cellar: :any_skip_relocation, ventura:        "a2cccf02a3885ffb4c04810b29b71f107596a875c0cad654f4de47c05166e448"
    sha256 cellar: :any_skip_relocation, monterey:       "82b01ceb54c4bdc9be1c92e51058bcb003387c9d64e65ba59704edd44ce25a98"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e13a5aaa5365e7a2dee8d01cf12fc499a832545e146c9b343f3966b1e4441bd"
    sha256 cellar: :any_skip_relocation, catalina:       "a2858248da2aa75092ab3511c6f9922bc85227e07c27444371e8d75931668bee"
    sha256 cellar: :any_skip_relocation, mojave:         "3aa20db4c47b16166b385d3e7e0c7af903833333757af7b1e0909dec00824ce2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d0a8416434aa03573dcbadebd135fbcfa6f4829934622ab8afe68aa496ec5e48"
    sha256 cellar: :any_skip_relocation, sierra:         "0bc4290c65271b84aec455adbaf85795857b19102e6efb152a64623420ae5757"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e4295866cda2370aa37cb1144ff1269ada4df6b76145a25efaf072d7a6b09b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a42de6a209af1dd02c8544621f7da76afabd415d46265b548b3e35b7667b45d"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/advdiff", "-V"
    system "#{bin}/advscan", "-V"
  end
end
