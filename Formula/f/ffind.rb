class Ffind < Formula
  desc "Friendlier find"
  homepage "https://github.com/sjl/friendly-find"
  url "https://github.com/sjl/friendly-find/archive/v1.0.1.tar.gz"
  sha256 "cf30e09365750a197f7e041ec9bbdd40daf1301e566cd0b1a423bf71582aad8d"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8fd5e399110b236d851503a23d805401c82799c3a43cd30a5ab03ee7adc3088c"
  end

  conflicts_with "sleuthkit",
    because: "both install a `ffind` executable"

  def install
    bin.install "ffind"
  end

  test do
    system "#{bin}/ffind"
  end
end
