class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.60.0.tar.gz"
  sha256 "8bcc40da0cb05a505633ed9219a2b5bdb900793b5413356572a4e5f1af1996cb"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b804ff6dc3674ddffa8b3c052ef8df6423c440dabbae3de993a7b42f9908ddd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6b0d8b481c210081c860b25d1af0b6fcb5de1c92effbeb4f99949c73a31363"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a1c14103b565df44ec42a68e2028d5f9ffa87c496d188e005aa605a6ce9ff57"
    sha256 cellar: :any_skip_relocation, ventura:        "85d0f1c808bd12f39687426a0417fdf78339c746e58ce7f6bc6c686d18fed009"
    sha256 cellar: :any_skip_relocation, monterey:       "99296dc577d8574c7748cae993f138fddec29e8878c8c0ad5da61d715a4fdf01"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4cb3fc8ab15c0bb6cc6c4b6524c5e42c018dd7284e9e1a70f8c448d410b865d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0795a6c4c7056f28607b0bc16e028352e827eb22bd73be1c1c008004fa5a2afe"
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
