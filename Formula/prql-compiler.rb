class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.11.tar.gz"
  sha256 "cf2ea9b7e7a3398998a361a54f2a8c2d5043f754394cff521954dcc22cea5248"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "152011c66588e571f3d6def4f38578ab49d08e7de2060a9feea05e528b2217f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cbb0274e20988a91eee86c4ed4d56f396cbb934687dcbff318304e9402f55dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "882936167e19c270b32b88c7e4eed201444c9eb08825b479125dde61985b10d7"
    sha256 cellar: :any_skip_relocation, monterey:       "523c58eaea44cc264cdfa1ad0b540b0a8e92bc5bc99ec6b018642993ad0fa9bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f57d9979a449a45cd66a3329b84e8e459f09952fe7a872b5fe85bf81563b8ca"
    sha256 cellar: :any_skip_relocation, catalina:       "d7c41392d3f4bc4c45e2ae2623121d7754e9d06bf7337b06daf9d2f1e44558b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1022e6137017e2fba19998a1043e5ff3a77acb52d674aea012786050f88b0aa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
