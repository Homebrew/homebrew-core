class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.9.tar.gz"
  sha256 "a7c97d347b799dfdc7999493c90bddcffca27251a6fcc6e036db67527fd309fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c5bbfb20d28d3b15b73f61da15bc4db0cb9feddf3f10008fd7083628a74f4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "815004911782ac9076f4a986d4576b2db882aefc6de6d307f496908aef356e55"
    sha256 cellar: :any_skip_relocation, monterey:       "c6c8ac72f9640c2f728a380275696c95148a5402807ebcedc21363df9814b82f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebcd4e4e6b116c10c3206d5176f1c3b784e7a93c0c4d7e6e6219a9d593d13af3"
    sha256 cellar: :any_skip_relocation, catalina:       "52b914e9c53ec6639f7bb7839a4ec8a2661b49fa13e7a4ed5dbd92549a0bf44e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "100a413167c33f8d1515e8282dd1b3a9266782a3fa9c23c7a07b96bce96962da"
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
