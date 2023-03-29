class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.64.0.tar.gz"
  sha256 "9067e7fee99d697d69d90a9473be27dcc3fe88c871d5c701405501726c936c55"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58cb62d4fd59583f646aab1c7242d4b8dbcfb8e6339dea85bb34a9320a3ad9db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "148e683dbf45e64fcd91c3c081403cc9b373f5f63810319324b695e8ae3f09c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a7daaee9550b99dac76b82b50efcb37a3550ec8b51e818b8b93da57d267d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "eeed9d5bdb71bc73b3545408a9bf7a37168b3d5bb0efb46dd89f7a2efb956a32"
    sha256 cellar: :any_skip_relocation, monterey:       "f3dcb3d2844ccebe64b540f29870179f342554e90d917eaab1db8f1bd151c66c"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0ec5d137bea6aa28e22776c2562549bdbb95cf6e1d9b1343456c27b21c0898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b433f28f4f2da4bfa9a53cff8a09edbbb1c1300a3ef2b67cf3678ef54416a6ba"
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
