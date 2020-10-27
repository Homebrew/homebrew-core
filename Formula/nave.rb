class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.2.2.tar.gz"
  sha256 "a8eb92bb47f6d00326b710f086aea23ae76ceadd277f79256263f524d3540ed1"
  license "ISC"
  head "https://github.com/isaacs/nave.git"

  bottle :unneeded

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
