class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7b3f7f89918a0c35864ba97a1536ecc7d78805ea79008dce1c74dffaad2a225f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8665f9344bd59d8d1ca29f033abc8db6616078e57fe991e781771c6e43f7113a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53a0ab6f94d0b7bbafada815a25b5159ac3d0fed4073714526bbd4350ec5df63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac972445b713681140e05905b842621e3d5e845f4a697686f7d9d5578eb9a53b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f031fe7a7fcb2f3184a2b5e07339d6b400c3d776d43f6b1a1a62bdaaf49eed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edf3274971a23adffeca610c2ec178698fea761c728f6b92a6610da67695dcbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a161d438152b4c290a63851c40120e0b44bd58821de237fecc3f5ef6ae8dd590"
    sha256 cellar: :any_skip_relocation, ventura:        "a2cccf02a3885ffb4c04810b29b71f107596a875c0cad654f4de47c05166e448"
    sha256 cellar: :any_skip_relocation, monterey:       "82b01ceb54c4bdc9be1c92e51058bcb003387c9d64e65ba59704edd44ce25a98"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e13a5aaa5365e7a2dee8d01cf12fc499a832545e146c9b343f3966b1e4441bd"
    sha256 cellar: :any_skip_relocation, catalina:       "a2858248da2aa75092ab3511c6f9922bc85227e07c27444371e8d75931668bee"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8e27855b2b171f2bedb2bf89d28c2ea3f1178951fdfe1b7ec2540fdca51f1439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a42de6a209af1dd02c8544621f7da76afabd415d46265b548b3e35b7667b45d"
  end

  uses_from_macos "zlib"

  def install
    ENV.cxx11

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"advdiff", "-V"
    system bin/"advscan", "-V"
  end
end
