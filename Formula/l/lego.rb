class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.14.0.tar.gz"
  sha256 "273b84a235bd90db45a30e395151eddaefdf674fec13f7cf1f2fd6f8235284b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11a31e19ffb5c5091244fe7a693c12aefa14553f23d1060fae7084bdfc713748"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9402b8e650e9dee9db4ea01197e84ab2404b82c6db055ef707a1ed42f99c8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4df8c51163388006da11443714cd58f3bcd66ad42bc2053a0ffa4449c7b33e11"
    sha256 cellar: :any_skip_relocation, ventura:        "a89f3768b8f1f7549f627c06aad5a5ac0581bde99ae7e6a0d35496d7c9dcd3a9"
    sha256 cellar: :any_skip_relocation, monterey:       "820e5c74e7ce0e38f5bf91ee363f63a000fdd242a599c7e2d0e51f99d1d54297"
    sha256 cellar: :any_skip_relocation, big_sur:        "2acbe66645d4ed9613df435c20f7ff4a20c6214619de7e186ce552da08730d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1590c8109c36cf4a74625141242908b018208a0104a0c7d0168a6020e5bc6156"
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
