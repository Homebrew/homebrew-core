class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.41.0.tar.gz"
  sha256 "e838e89c9e53c382defb78cc5d3dd00cb530b8832c336aefe3094230b646bd93"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9fef3e64232ade882fce55a355e532e7cc2e178969a49b03f74cfbe04b48455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5bdd35d319749197ef90d59ffe281d569c5e3b4c36b64b11b6b8c6788227225"
    sha256 cellar: :any_skip_relocation, monterey:       "4c1e9d326715ac82162c4b3bed186d5ae1fe9fa23a4a5d00510d4731bda501d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "08458b9c17d6681b3e32a0e13ec773db019e1c00fb3b0c016ae204290620e376"
    sha256 cellar: :any_skip_relocation, catalina:       "b87d9a41f92214ac61670bb652d024a7a7355d41c0c5cb79f7398f52d7ae87dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44d68e98cf104dbe631050c4f7c75d655c1f042ff0773c6315e1e7169d75a1e7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
