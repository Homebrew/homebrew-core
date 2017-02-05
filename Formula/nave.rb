class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v2.1.0.tar.gz"
  sha256 "1785ed898a4cfd3e5451aaa2cf9e236ceebe810f01bf8f9eb51722298b59f62e"
  head "https://github.com/isaacs/nave.git"

  bottle :unneeded

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
