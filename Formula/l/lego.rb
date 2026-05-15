class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.0.4.tar.gz"
  sha256 "087b8cd794fc76c65abc3c26dbfb726e04287c201aa9250f271a865a173754ae"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1b78e1e68f2b082afe96caec276235e2f5563fda5d660cd19f98e1781c9ab2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1b78e1e68f2b082afe96caec276235e2f5563fda5d660cd19f98e1781c9ab2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1b78e1e68f2b082afe96caec276235e2f5563fda5d660cd19f98e1781c9ab2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5749ad68a7a577f9725cd777f64ac42dc1fe8550ee44fc8fd26ebcc70146b8ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6ea5d7dc1805dcb688c7ad426ccdeb5ded79c0f7da607384ff790375f1f99cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d76d7d07f3929e662c08b220995755357e1e8b34ab2aa02d4fa28af0f92382"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
