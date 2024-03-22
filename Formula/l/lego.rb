class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.16.1.tar.gz"
  sha256 "40dcd261dc92f81e0667137efcf4799b8ccc67dc3e3d0b1e29c3d0fa71f40f88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "533d11299e32cae2786170ae5c63f2488de94068ce562ec6b04cdf7e67f40148"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff3743fe3c721dc9441626114c0f84c117a09209c0b97b0002f1e585394ee33c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b5463ca6548e8ce61f77c11cea9ee68157b5dc64d9ef876d7af9a556f9c8b60"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fb468b9c09ea828373f499543cc3d863865762fde2aa9a2f5204e97d79a6ff5"
    sha256 cellar: :any_skip_relocation, ventura:        "79e1caa69d6a9b090ea83278601bf9ad4a79c264df8bbb30bea11046a041b6b4"
    sha256 cellar: :any_skip_relocation, monterey:       "5548cbc42508e552ffb3ae12d25797bf306502d793fb727bfd0e23d87f0262f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640209959680b23e95bd5b981f47e068b3984f59b576d89844565e5aa0f849b3"
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
