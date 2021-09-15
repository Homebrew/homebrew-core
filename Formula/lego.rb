class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.4.0.tar.gz"
  sha256 "3c1261fe1a774a9aea2f1bcacd9cb5fea8213cd343c6e5e68f78bff90cfd5b16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bde260758c983529fde3c977a23e4e3e4e664749ddb97540c635720b49306c3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c675b222bc4565645416446e6d1332b4feceec7a86dd43b8a6d7831b4247a7a"
    sha256 cellar: :any_skip_relocation, catalina:      "f6161edd3d53d528adb7914e0b3bd8138445defad7b16ccc9e33c445c30ee191"
    sha256 cellar: :any_skip_relocation, mojave:        "ee323c32f8bc460f203dc515c1cc0e32facc76844ff9bd31e5629ef42de8914b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd242b61582a48304a07e0af704090e3acb43d844dfb86cf44f8c649699ad202"
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
