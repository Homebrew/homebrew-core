class Ffind < Formula
  desc "Friendlier find"
  homepage "https://github.com/sjl/friendly-find"
  url "https://github.com/sjl/friendly-find/archive/v1.0.1.tar.gz"
  sha256 "cf30e09365750a197f7e041ec9bbdd40daf1301e566cd0b1a423bf71582aad8d"

  bottle :unneeded

  conflicts_with "sleuthkit",
    :because => "both install a 'ffind' executable."

  def install
    bin.install "ffind"
  end

  test do
    system "#{bin}/ffind"
  end
end
