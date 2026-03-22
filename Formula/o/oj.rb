class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "6c6910b01967532a199d05599c0ee83df9f732b3721d90e6a618e3e13e3d41fa"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2646c08f3725d3002c63ecb5b0840d84a4758e2c90d3b93743f9277d8f63f566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2646c08f3725d3002c63ecb5b0840d84a4758e2c90d3b93743f9277d8f63f566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2646c08f3725d3002c63ecb5b0840d84a4758e2c90d3b93743f9277d8f63f566"
    sha256 cellar: :any_skip_relocation, sonoma:        "671141d6f3d5ba9adfeb29df5731a4b6e071992518ced24a8791057adf27ba3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52b109bc176c0afc9081752f1f1e2197b74ec7e3fd5494155797e112520c5b4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4242ec4389c3d0a287b87028adcc8713abab8b46e720a9cea64995371fee59d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
