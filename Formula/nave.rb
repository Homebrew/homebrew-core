class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v2.2.4.tar.gz"
  sha256 "ea14cd9f8e9fc8c8ce9b1a6aec4b25148bc742d979724bc15a2ef2b0c0bb9dc7"
  head "https://github.com/isaacs/nave.git"

  bottle :unneeded

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
