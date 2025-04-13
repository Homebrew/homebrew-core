class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.22.2.tar.gz"
  sha256 "d4d5a3032d1ed99a5cdf551b2555288c3fcd961be536e58f477dce35d22c8702"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86c41acd41d7c11fd2a2bbd83122f14b5a9dc560dffb71713a1df4389d6de15a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c41acd41d7c11fd2a2bbd83122f14b5a9dc560dffb71713a1df4389d6de15a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86c41acd41d7c11fd2a2bbd83122f14b5a9dc560dffb71713a1df4389d6de15a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40196fd9bdd9aec1abc9ddcd322e4cd869f26c39b80d22c2b5c203ee864cceac"
    sha256 cellar: :any_skip_relocation, ventura:       "40196fd9bdd9aec1abc9ddcd322e4cd869f26c39b80d22c2b5c203ee864cceac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d04eb47989fc398273beca74f22686e39f27a32b4a261c1a548d15ca7db47b36"
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
