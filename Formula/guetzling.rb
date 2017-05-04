class Guetzling < Formula
  desc "Tool to automate image compression using the Guetzli algorithm."
  homepage "https://github.com/lejacobroy/Guetzling/tree/1.0.0"
  url "https://github.com/lejacobroy/Guetzling/archive/1.0.0.tar.gz"
  sha256 "a645587ad55916a1e977fb4b457390d6bef354e6b871b3a21514a9501e3a870f"

  depends_on "guetzli"

  def install
    bin.install "guetzling"
  end

  test do
    system "curl", "http://i.imgur.com/BljEIfj.jpg"
    system "#{bin}/guetzling"
    system "true"
  end
end
