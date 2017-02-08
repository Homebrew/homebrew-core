class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "http://www.catb.org/~esr/greed/greed-4.1.tar.gz"
  sha256 "2356151b2f95badcb8ad413ca88ee7022a46b11b2edab5b096de6d033778b1ea"
  head "https://gitlab.com/esr/greed.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a34bc7c0d767d0687f2d302173b1a93977512f11106e78269e82faf8d824957" => :el_capitan
    sha256 "122677213cbe13f011da1b06ebea4f24812c6c8a3c68f702151922f665dfaaec" => :yosemite
    sha256 "72c17694248c5bd5a8cba9947e2f04a6475116b8ed5d04a6b45a35c6f95101fb" => :mavericks
  end

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats; <<-EOS.undent
    High scores will be stored in the following location:
      #{var}/greed/greed.hs
    EOS
  end

  test do
    File.executable? "#{bin}/greed"
  end
end
