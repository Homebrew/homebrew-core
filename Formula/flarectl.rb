class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.60.0.tar.gz"
  sha256 "8bcc40da0cb05a505633ed9219a2b5bdb900793b5413356572a4e5f1af1996cb"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8395771e755bc01f5f2577d2a8b8392ebefc783e89251f8697e1ffedc5f3f73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec86596c6649fdc6fdc76ccb695cc0e0a4e101c539028c00203514a437a631d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87341ec6d5a2c723a4f7babcb35229ae21f8366fa0e3a8ffb4e5f87134028fbd"
    sha256 cellar: :any_skip_relocation, ventura:        "0c374d12231b694d8976a17509c57c296bcf90a79c93a41d23cf1608f8073b00"
    sha256 cellar: :any_skip_relocation, monterey:       "1726186a7fbf3857279bc6a1f8dacfd9b7cdbd9f0dd9ef8d97b2a3eb13c17d39"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9b80c098692f90abaa2586996bf5b84706609e66d610fef74ab340961967408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3be806ce40372982df2444bafedfbb2782a2aae36348310570248f6fed1aa81"
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
