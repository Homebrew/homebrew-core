class Advancescan < Formula
  desc "Rom manager for AdvanceMAME/MESS"
  homepage "https://www.advancemame.it/scan-readme.html"
  url "https://github.com/amadvance/advancescan/releases/download/v1.18/advancescan-1.18.tar.gz"
  sha256 "8c346c6578a1486ca01774f30c3e678058b9b8b02f265119776d523358d24672"

  bottle do
    cellar :any_skip_relocation
    sha256 "3aa20db4c47b16166b385d3e7e0c7af903833333757af7b1e0909dec00824ce2" => :mojave
    sha256 "d0a8416434aa03573dcbadebd135fbcfa6f4829934622ab8afe68aa496ec5e48" => :high_sierra
    sha256 "0bc4290c65271b84aec455adbaf85795857b19102e6efb152a64623420ae5757" => :sierra
    sha256 "e4295866cda2370aa37cb1144ff1269ada4df6b76145a25efaf072d7a6b09b5c" => :el_capitan
    sha256 "f91cbe31c7c8072fffffcd0cc8766e20df6f728abc73f66140f97c0a49d6f6c8" => :yosemite
  end

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
