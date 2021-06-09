class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.4.0.tar.gz"
  sha256 "3c1261fe1a774a9aea2f1bcacd9cb5fea8213cd343c6e5e68f78bff90cfd5b16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98cf7e41c76fcc8f436778c5102d3d813b76fbb38e6d41b890fde18c77a47dd0"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c5efe9cc6e0888bb78e53e089e7c1ac16f15f71e6894c1cbadab80e12b552db"
    sha256 cellar: :any_skip_relocation, catalina:      "0304f6caefbffc8376d48aaf77e9de929e9e9036a3f825575660b45cd21db558"
    sha256 cellar: :any_skip_relocation, mojave:        "84bcdd94d87727e85526053220e2baa01195efc9ef795c9d2ac4e596074dbc18"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
