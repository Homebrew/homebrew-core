class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.16.1.tar.gz"
  sha256 "40dcd261dc92f81e0667137efcf4799b8ccc67dc3e3d0b1e29c3d0fa71f40f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae7867542eadb81182f2c9d1e14b8cb11caa32719e63c2277823f513b35918c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f99b8fda6da0d44a9545c6e8e466ab5151084dec2f57c20bf92346176903c0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5f3d69f8b152d3a970375b6790ceabd092b05aba82978dbcc6e2ddeeb14db90"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c154c53d885c9c4e5b4e248cef6da5e064f7c9ad16e1f9f18e6ec40cc92bf4d"
    sha256 cellar: :any_skip_relocation, ventura:        "c064c947a5e019b674145b26f40d25fcc110ba9dd4133c79f08fcbb7baf43483"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3d25b69033774dda193aef5ea7001a4f606dbcec68b6104ae06b80485fb0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5016f9a7e4d29e8015dc820eb002d19c02e1550b795f2cb1a06cd610ad12a9"
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
