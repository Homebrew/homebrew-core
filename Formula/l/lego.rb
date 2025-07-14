class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.24.0.tar.gz"
  sha256 "5ab0d770551b1cb7210e837caebed323ce1cbf5898dd30443d6fd27b283202b1"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b72f78c252e5d5a607b32216e0a2d6db66756ec8f854d6b53e7c68b84f49e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b72f78c252e5d5a607b32216e0a2d6db66756ec8f854d6b53e7c68b84f49e5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b72f78c252e5d5a607b32216e0a2d6db66756ec8f854d6b53e7c68b84f49e5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b9964c16779a4deed7ee4ff66d45f6fec354bd034df2eab886bf8561e1d2296"
    sha256 cellar: :any_skip_relocation, ventura:       "7b9964c16779a4deed7ee4ff66d45f6fec354bd034df2eab886bf8561e1d2296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "518bd8e06123264d6d6ab49e7e7dfbcbeac15bc7327285fc343ef030963a9c2b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
