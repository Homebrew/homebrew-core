class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/refs/tags/v3.5.6.tar.gz"
  sha256 "d5360cbfe3afda8622fa838183eec53503f8e3f4e08c224b5b1458159f30a99e"
  license "BlueOak-1.0.0"
  head "https://github.com/isaacs/nave.git", branch: "main"

  bottle do
    manifest_sha256 "71cb44fd354ea8036c96641dca2e7d89b1101372cd2ce9a3b0c73c7e993c6a3d"
    sha256 cellar: :any_skip_relocation, all: "7f476c7839cadc0d37a067e2fd4b5d2de7fccbba142e6aa8d9aeb92e984587c2"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
