class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.7.tar.gz"
  sha256 "4d8dca19dae441381a61033437c8b93c205188ede2cbc847c6cf89e54c69d6da"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "41edf2474a6f635acc6a215be9fe1532d71712bc199bce2b01a865c577e1f8a1" => :big_sur
    sha256 "159953cf7fa1bd6179f2db2c9cb3f6c6f7f8c840d9226d10b5bb00a60c330a16" => :arm64_big_sur
    sha256 "cd3f1d364ea956fb526084ed4acf931b2928cd280d3b011f9b81679de098c408" => :catalina
    sha256 "ae3a645a613c275984c9fe9dc0cca7597daed485e98bc1270d5e91327c01b0d2" => :mojave
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
