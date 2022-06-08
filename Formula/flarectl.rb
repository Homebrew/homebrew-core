class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.41.0.tar.gz"
  sha256 "e838e89c9e53c382defb78cc5d3dd00cb530b8832c336aefe3094230b646bd93"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6a46dd605242ed6b5ab4795019dd4c60650a7f9962f142b54bceba75bb9841"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad2f033e06b88fac2124f288efee2fb29a32b8c32d93de5738d049c12bea7849"
    sha256 cellar: :any_skip_relocation, monterey:       "967fc52d942cb41d6fc7e3f4523f5eea40dddbcc602170869b10bf03f9581607"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3bdd15ae14e52e4ebcec7abea126890ae46dd7aab4cd56e4c129e50758942e0"
    sha256 cellar: :any_skip_relocation, catalina:       "4a4fa7adaa0822a8e4faeb31939670b645c2a94883556bc9647bc6a69371977f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58d4be684ee41d1feee65952489eb9042d1649d6cd819f39af65844cf4c00d18"
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
