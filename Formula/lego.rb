class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.9.0.tar.gz"
  sha256 "e54b21f8e12a98af7476cf376a1b816889d2a9424bd80ec367abb5d6eaf0e4c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1614f1bd4a7fff7ceb2eae01d16ee7d114b36c6973e846e2b62d66c6494a27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7576733ae6ded208c8ae8ee6702fc56f5ffe999fa44b7df89c3d7aa0e5b59a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c3c84b4f05f5ae33b8b7e5e26584c336e335ca53e41b4c150725eabe2bff16"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec037467befe2042b3ccbef9a523d35ae7e07620d28d4781650a47dc8cd24317"
    sha256 cellar: :any_skip_relocation, catalina:       "dac48b36424dacd2e878be7e406721096dd308d1013a5313f33d276f1fec9247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25933b7c4d06bf96e4e3f4a1290011499260c0c31523fe33741ec929036aeb08"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
