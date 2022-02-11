class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.32.0.tar.gz"
  sha256 "cbae73969c538f41698042baf8f6a5bb3c9431ba4f05e47d8b75c908a960a5dc"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9d4b9e82f904ae91f1d2dc5aec6912c4b403aba0340301379efd226abb1917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1d990310a12e816582837dacb7d4d7fe6e13470c60714b7fd23e5a4c58c2c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "26b4dbb7d32ffb169bad7382cdd042be1721f936cc12df643722773d1685011c"
    sha256 cellar: :any_skip_relocation, big_sur:        "820b61f1c1df6c0af5110cff8d80f50201b2991285757bb8159c9b2782f8c0a4"
    sha256 cellar: :any_skip_relocation, catalina:       "9b56c29f5c6387bb65d2ad5427391d123b0e1bfac52c8eea6cc8af4bc9d63aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a8983730fc1262a5aaafbc00652385b30acea7c2e7b885c206559fbe79d607a"
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
