class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/refs/tags/v3.5.5.tar.gz"
  sha256 "102b1fced7aad7746cbe9c1871984cea2560747f0369fb777857c1992dc09a7a"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "cf0777ec6f533a7c1d68910219d1d5d87d5e75c01411e39113781bfea4ba31ee"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
