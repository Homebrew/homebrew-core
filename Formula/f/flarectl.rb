class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "23ad69a54f8a0e545d135d4a3dc002a76ccba8991b63dc6b8ac06e47d95ea274"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18497e067c909f2f669ce0ceba98498305ce974a21629e5e141f890ad5428d5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "565e968e142bc5ad9d7935d58006baaacff2d96fb233b62c9ea7700efefebf7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "801a94efaa1998ee7002dbc6d06a14be596f06f3eea9a5afdeef3a57ac0bd5a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "77cc84e574b44c7a7c6cc945b4cdc1a507574683b0d07b948a69aa9dbdff32a3"
    sha256 cellar: :any_skip_relocation, ventura:        "dfdc721af75525d186e665c0847ed566e25a651dfaeed0957e3fcabcd0c8dcb9"
    sha256 cellar: :any_skip_relocation, monterey:       "6413a6f8916a2a0937cc2b8ea0fe4425576d112b1913cd2ccef228388359ee19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c404cfee2cc22740dfab2097ede4559095b19539326f28de2b221aa41711b1ec"
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
