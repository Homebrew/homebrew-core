class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.13.8.tar.gz"
  sha256 "a9b599b1bcb190e75c294cc96fe8b476c88dae06f3aad046a388e0c15ab8e149"
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

  # remove in next release
  patch do
    url "https://github.com/chenrui333/cloudflare-go/commit/5c74c62.patch?full_index=1"
    sha256 "428c3504205af52b90a4d16e07ba7069e71ac2546787f9b6218ccb4784975b09"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i", 1)
  end
end
