class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/wrangler"
  url "https://github.com/cloudflare/wrangler/archive/v1.19.3.tar.gz"
  sha256 "0e1a598c362564395f53d91a1b6225881e55492c3df554475d7d0dbc2a4db06d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cloudflare/wrangler.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd4f8cb1b47941301023218fb1426ea3d9310ff2e50ae57b1cd7f4ad6a897183"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ee3260b0bae182e891d0dc6e4a061d9173d870f9bec1f428277a574248364fa"
    sha256 cellar: :any_skip_relocation, catalina:      "2687bd15305fb01d7e27bfcf04968893033662da7496630246cdd727d8c18585"
    sha256 cellar: :any_skip_relocation, mojave:        "247cb94e3eea2f7da5f334dedb0de1bd690097c87ea27b385d0d441860650caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fe8f17ead54b92b365ce717e8f0d7b1c6d54b18a6d4fb5d3be0eebc6a5cfa75"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CF_API_TOKEN=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA #{bin}/wrangler whoami 2>&1", 1)
    assert_match "Failed to retrieve information about the email associated with", output
  end
end
