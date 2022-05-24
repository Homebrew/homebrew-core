class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.39.0.tar.gz"
  sha256 "a36817b13e522090c3e3c3179e6826c497a835e2f6adbc1b75b2342707ef7b85"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100ebbe899f81aa9b7d031ec1a8c35ba83993cb8849f451fa93e2aadf171be3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd57d841ea031ca9e3a9eecf6d63c8ce3282d22247a2dfba491cded31feae417"
    sha256 cellar: :any_skip_relocation, monterey:       "77beef33039f1bc2e9a79586aa5d51a4ea9075f175e7b478bd9330f9689bdcb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c099f5960387d6e1b79f8517d4876a99c8e72f2fac50a9c2a3782670efb2fbe"
    sha256 cellar: :any_skip_relocation, catalina:       "22a3f9ee53249cda272f8b88588154d18372aa7a1bef96321015547adab717da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501566b78059f068821949edc821b12a9194c7be405e5ff49924158c748f8ec3"
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
