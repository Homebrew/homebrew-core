class Ffind < Formula
  desc "Friendlier find"
  homepage "https://github.com/sjl/friendly-find"
  url "https://github.com/sjl/friendly-find/archive/v1.0.0.tar.gz"
  sha256 "2eca8563bb77bd4bae84b3f0cbe104c0289698b29fbe22d67d007dc36af5f700"

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
