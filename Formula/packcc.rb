class Packcc < Formula
  desc "A packrat parser generator for C"
  homepage "https://sourceforge.net/projects/packcc/"
  url "https://master.dl.sourceforge.net/project/packcc/packcc-1.2.0/packcc.c"
  sha256 "06e2dc028e7021c46c750c1ee74fe03b308c79785bce4f30bbe1e5a2ed1853e3"

  def install
    system "cc", "-o", "packcc", "packcc.c"
    bin.install "packcc"
  end

  test do
    system "#{bin}/packcc", "-v"
  end
end
