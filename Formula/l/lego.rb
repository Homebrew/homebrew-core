class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.13.3.tar.gz"
  sha256 "a0d38442a8781f4c0f46b37eb026d74b15d0e54f54d04f52a86dd51d7ec4f6a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb5cfcf80b25c888f9d3d1c53d6c40ae6eea096fcd3309c304b290f107291023"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5cfcf80b25c888f9d3d1c53d6c40ae6eea096fcd3309c304b290f107291023"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb5cfcf80b25c888f9d3d1c53d6c40ae6eea096fcd3309c304b290f107291023"
    sha256 cellar: :any_skip_relocation, ventura:        "a71af52f127a3b5f774a354fbaa18a4c799044309e5121fd61974d4c8413ef3d"
    sha256 cellar: :any_skip_relocation, monterey:       "a71af52f127a3b5f774a354fbaa18a4c799044309e5121fd61974d4c8413ef3d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a71af52f127a3b5f774a354fbaa18a4c799044309e5121fd61974d4c8413ef3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c8d684705a30b81a136a64b8a8870c7d724cb2430c2d3f30b294e022eef5357"
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
