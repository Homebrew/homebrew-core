class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.62.0.tar.gz"
  sha256 "09aff7470cfef300f0252e8d9dc073f7d13e76504d42e1c8dcb7bac4ed130bca"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512443c196c1d3ca60635f570b423b3e9fa2e08593beabee6c22e1454e31cbf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c27bc36736549f44ad0110a564caed2cd3ca589a6f702c6f7d9a3a5dd12890d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2efc8438813c2675c98e8048490b5e1379ddf03c96480b0e9dd949def2477a25"
    sha256 cellar: :any_skip_relocation, ventura:        "a8073fc9b38a3323fec556a8cb555c162018459b0258b8220774f57fb0f9f124"
    sha256 cellar: :any_skip_relocation, monterey:       "8b219716fc91eaa91662aac7fc2edd50138704c7a37704e75cdb60b5fd780af5"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e51d3edc3372a4cbd0ec127456a1fb5d8a92983fdf12afafc7ee36e1e7a0c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edcf416474cb6cefe372dd316f8908c7e6391f432b028a9ede35fcdfe6f66bbb"
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
