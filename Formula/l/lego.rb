class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "0d8c5583717559bd33631b366c73bd0b46b332a3e50362a84db2ad299e284c75"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "514b25ec3a809cb9d016ec1f038435c833bf7676524743f7bd9e3b21fe9b5d72"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0bcd4ff4aa22bdbd01c2aaee86835bbf22982b76364cc8345de6db818941416e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0bcd4ff4aa22bdbd01c2aaee86835bbf22982b76364cc8345de6db818941416e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0bcd4ff4aa22bdbd01c2aaee86835bbf22982b76364cc8345de6db818941416e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a94d436538b3dc380226e31192afabc461f05fee6b04d9c53a4c3ed4aceacfff"
    sha256 cellar: :any,                 x86_64_linux:      "a41599f25fd20142fd65df64dcac92acb47e3e949d370fd93ce12176c6a4fa2d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
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
