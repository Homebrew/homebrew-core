class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.13.tar.gz"
  sha256 "e4348c908406c2aaeeb4715cbe168f793237ff6a6deaeeacca2ef95b05b4b4f2"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e747cbc2eba184689831309e61fc2de0592fface31b6774ed807d5d4228ab921" => :high_sierra
    sha256 "25321f9c9f1949df28c1a92d00eece1c5370fbcaa3f3d15f2671ce448308ca85" => :sierra
    sha256 "d177ded631d552d3947594d6de9bff5926a44a819c7968048231e05083336423" => :el_capitan
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
