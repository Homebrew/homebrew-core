class Neatvi < Formula
  desc "ex/vi clone for editing bidirectional uft-8 text"
  homepage "http://repo.or.cz/w/neatvi.git"
  url "git://repo.or.cz/neatvi.git",
    :tag => "05", :revision => "ed2e096607df03ce155e4c6ab786f8b697799988"

  head "git://repo.or.cz/neatvi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a085add28099e0a112efab55d61d3c339419129848181cf0ca2bf3e278807e0a" => :sierra
    sha256 "39a2a3b6e82806ea132ae6a3242147feb497c31c04ce68f62e93c4d808ca0d22" => :el_capitan
    sha256 "904e045bf6bd1dea374e9091882cdf25a80fe786bbee9cfa42d0221228ec01d8" => :yosemite
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
