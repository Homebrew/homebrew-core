class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.19.0.tar.gz"
  sha256 "f0ed63950bfed416d0f085e4e753d27d8a9baf0d2f1f83670900a73336809926"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fbca17e5e9a6dfa51c05356e1b3e22b3bb805cc02a3264016d65e7f63b806bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c2f48198036cfbdae0e89c7babf81348b984b2e5137b0c9a7aaa2042658c517"
    sha256 cellar: :any_skip_relocation, catalina:      "907302eec2e481e02f9c3d656e255a70828838ce6bf65d6bd15285769dc7658e"
    sha256 cellar: :any_skip_relocation, mojave:        "b12ae3a2020afd2189c3de0866b4b851bfbe981a0fdb579244514a9364de5ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8954281e768ecac38c1dbac23bdca7ba82498f53db8657bb6afdd28fc4217abc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "HTTP status 400: Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
