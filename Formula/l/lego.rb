class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.29.0.tar.gz"
  sha256 "58686e310d0952f150d600e8841cbdd7513fdab05f94b8e18b214d9f68c67219"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a65d10f7cfc41ed4c31561fe434042b13669d3786a64361a0b7b444fe4341335"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a65d10f7cfc41ed4c31561fe434042b13669d3786a64361a0b7b444fe4341335"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a65d10f7cfc41ed4c31561fe434042b13669d3786a64361a0b7b444fe4341335"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8463482784f0b915543954920539765a0afa5c41df2a3a86f4422d4062ca83d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cead00f41414e9ea679265cda68f1adcde9773f8ecdefd804b9bdc7afe425de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "186e40d563f536c53748f8b85b165d425269811e427ddaa47847cf7f783c0a4a"
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
