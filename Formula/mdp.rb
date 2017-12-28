class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.11.tar.gz"
  sha256 "885660432d77dfce9f443c518e595b2a3780b5883a06cc21e593d13af1afcf4a"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "33eba760559692e021171441d4c62444f503045150f65734b0d4c53fec4c8b9e" => :high_sierra
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
