class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.49.0.tar.gz"
  sha256 "43044abb5bafa20a7fda9ecfb952388bd1d016ebaa28b3e5c4a4fb6277ad6e83"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49123d9f6864d24533ae545afe1fcbef32efd8dde50dfe512103207e78542b01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8abccad4bdb93f9d386ceaa377eba72cd5c7833fb2f85e7dbc89c6da45fd9e32"
    sha256 cellar: :any_skip_relocation, monterey:       "945078db9b821996e794bd1580c57159ed14de5da176ea8bef8611bf796876ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "6de40b6950901637da4e53144fcbb170fce9316a828f293c85c05d6677c14094"
    sha256 cellar: :any_skip_relocation, catalina:       "74a28da2694a617c4d630f664e85e3dc3f4fc142c2202a77d76bb35a329b5e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eabdebb32ab3a0dd30fda659cfd20c3f18c3ee7310a36a47f283411f147cfa5"
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
