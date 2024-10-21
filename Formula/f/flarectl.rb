class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.107.0.tar.gz"
  sha256 "df2a178121a902473f0551493866a41e01c18baeb75f52b737890350da2c58ca"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0165305feef17f9d62d63822599e3285879ef17f15e498ae0ff1337b5941d282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0165305feef17f9d62d63822599e3285879ef17f15e498ae0ff1337b5941d282"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0165305feef17f9d62d63822599e3285879ef17f15e498ae0ff1337b5941d282"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5b8c886711edae2bec487cb4edea66b4575f6dd634d1a834a82f0ac3055227"
    sha256 cellar: :any_skip_relocation, ventura:       "9f5b8c886711edae2bec487cb4edea66b4575f6dd634d1a834a82f0ac3055227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53db0cb5e3c9f900f7a8a4eb3b4068b6883b89b6b790dfe45d7c7330b73c1345"
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
