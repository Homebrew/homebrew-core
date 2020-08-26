class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.1.tar.gz"
  sha256 "f59209fe1cb1cd9b3a4de51f4b82d03e25e4efe04c50fda0f969c806584104d4"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffd5f05f779bb2e10d5df7c33ec592cf7f09158ae16744175dff7504cc3fee5a" => :catalina
    sha256 "2ae9d69c1c49863261676210e3d19c35008becd60e2f3b6d219afcdfae1530ff" => :mojave
    sha256 "ec33f389866a93ab7f290a0d17ad287e2da64dee4173bda1527822ff27ad349e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
