class Dag < Formula
  desc "Download an asset from the latest Github release"
  homepage "https://github.com/devmatteini/dag"
  url "https://github.com/devmatteini/dag/archive/refs/tags/0.1.0.tar.gz"
  sha256 "138314c54636c3b191a84b15ff83050bea63ce000a2bbdce94290c37095e83e6"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "make", "release"
    bin.install Dir["target/release/dag"]
  end
end
