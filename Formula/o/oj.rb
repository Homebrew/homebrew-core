class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://github.com/ohler55/ojg/archive/refs/tags/v1.26.6.tar.gz"
  sha256 "85754da53ac0b717e1c9068c71a73315bbe666e10520de488a84c4fd124d5d8c"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "659d69c48c89cb841e50608103d70ad2f23a58899fed7b22ea0ed64455fb8cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "659d69c48c89cb841e50608103d70ad2f23a58899fed7b22ea0ed64455fb8cbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "659d69c48c89cb841e50608103d70ad2f23a58899fed7b22ea0ed64455fb8cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e8b7bbf89f0a231408f8ec64ab5b00d0578630b46e93f68bae6555021f82e06"
    sha256 cellar: :any_skip_relocation, ventura:       "8e8b7bbf89f0a231408f8ec64ab5b00d0578630b46e93f68bae6555021f82e06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a0c6208cf9b1155b53e3da21bb99085048f484e45c44b6095cb3206c5bb2a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcc78d06b2bf62ae33dc906c2575cae01751f4bed9b2dd49ffaa041af9a6ce0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end
