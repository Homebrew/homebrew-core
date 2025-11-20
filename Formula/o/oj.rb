class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "499a86d97180b942091095afa0aa7dc1c77e09d03a326ec2c078579dfe47d765"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "174054478c3287392d373e6d6e3d356c461dfbb839601729d2319da998d965c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "174054478c3287392d373e6d6e3d356c461dfbb839601729d2319da998d965c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174054478c3287392d373e6d6e3d356c461dfbb839601729d2319da998d965c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba2d020e71ebe4b2cd4f5e2bedc6e0f4fcc9f5622da18fe739dc972565d0c3a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "395df123121621bfb95e640676b5417da11b5d631a522eff1564bfcf1a1f0e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46874386e6d44b5475b273c28dbc531a8eae89218b59d132fd33368ca443d7c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
