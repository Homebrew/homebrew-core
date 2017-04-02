class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v2.2.3.tar.gz"
  sha256 "32aaca55ef182483c4f0b9830d38724bc12ef9d334d1a6dabd9facc66420eea9"
  head "https://github.com/isaacs/nave.git"

  bottle :unneeded

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
