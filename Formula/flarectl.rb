class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.58.1.tar.gz"
  sha256 "819ae94e23911aabdb5d6b42c4b489b73d3710c6308fbeb3794e11779e86f5cf"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe783e06da01b450a981e605f6575fbd1aebb71d74708a34b7008e1c64318eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd8750090149b7b9e514ec4ddaec377c1b2f3a3083110c0dddbe0f75cb0b530f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "613004b979376bbaba3801d0b5b40229e574df1ca059dbdeb5df6116baecf681"
    sha256 cellar: :any_skip_relocation, ventura:        "f9eb3c5c4553ad91623a47716a5a46dd4c3db099cfc37a932cd2328a39b1fb52"
    sha256 cellar: :any_skip_relocation, monterey:       "2e354e7f297ba02515e8db364d6b34d162735f302aa160ac6ceb1bd5d7be650e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6feedb746f8e32830d5816ba57251a235aad8703c35310a0868a69cde68a7d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0171f76ac9989dc6176cde3563aca27cea214b64afdb113a46463e9c56a9f160"
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
