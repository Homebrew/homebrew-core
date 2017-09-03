class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.10.tar.gz"
  sha256 "7384c1ba32bd8e4b11342570d2144165a60682499b4cb54e50c8eb3164cfabc5"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ede61a6bd6ece5dfc361f03b8bb9ef11fec560e4d49e2db66fd9d1df5e9693f" => :sierra
    sha256 "aae896e1e1b4b5615d0440cfc92e541dabcc760d7a9f60527655fbcb7c61ac93" => :el_capitan
    sha256 "1518c8a1c67a38cd92053823e21712712623d3637497f86b65807b982919d0c0" => :yosemite
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
