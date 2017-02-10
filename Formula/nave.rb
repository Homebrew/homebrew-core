class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v2.2.1.tar.gz"
  sha256 "50d8fd943429e4be884f7c441be71d0ec83a7569657357a077f8be2e55a5ca05"
  head "https://github.com/isaacs/nave.git"

  bottle :unneeded

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
