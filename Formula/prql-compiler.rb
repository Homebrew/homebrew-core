class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.4.tar.gz"
  sha256 "1cf0df56457426bf8dee2e4c7dba27a635fd21128ef4b7fc71e5125a26bfe4c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "985b241440bdee1fd64c8560d0a462155e32ea9cebba974f917f7d5adba12644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a4db3d184cf1117b026a0d908b65825f440d698de363822af0f4405971c0ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "a46c2a04bdca79f62b4d42b59f82f314f0ebc715c9e2b47e8a1126805e4e8461"
    sha256 cellar: :any_skip_relocation, big_sur:        "42b3e87e017c176e0e8ffff0c78caf9d196ca6acffa824050855ea2446f1136d"
    sha256 cellar: :any_skip_relocation, catalina:       "300810bf6f8cffd05b012e9ce0096f69fc09b646b0b82f36a46406fff3c1807e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ef62401645455cbd73ded39878b1b0dfeafe96368d3bfe6c5bb976e6b8c025"
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
