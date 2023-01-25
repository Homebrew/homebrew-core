class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.5.0.tar.gz"
  sha256 "009c96bdbbef66180796feb94b75e13a394934bc7093621851a19a1ab7d2916d"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "890868f3c01fec6535abe4daeb7f01bf1406752f29034dd7b86c22ce3a1ad446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "890868f3c01fec6535abe4daeb7f01bf1406752f29034dd7b86c22ce3a1ad446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "890868f3c01fec6535abe4daeb7f01bf1406752f29034dd7b86c22ce3a1ad446"
    sha256 cellar: :any_skip_relocation, ventura:        "0b1e29dd90ffd9d6b7985a5a6384f95ed8bfb0d7bbf29d462796133758611c84"
    sha256 cellar: :any_skip_relocation, monterey:       "0b1e29dd90ffd9d6b7985a5a6384f95ed8bfb0d7bbf29d462796133758611c84"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b1e29dd90ffd9d6b7985a5a6384f95ed8bfb0d7bbf29d462796133758611c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890868f3c01fec6535abe4daeb7f01bf1406752f29034dd7b86c22ce3a1ad446"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
