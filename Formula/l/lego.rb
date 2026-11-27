class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "c536853627d2480611cc728819b400d994cd02c02df6711808552183b762cb15"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "52bfab1ca6ad8e5edce23634062b2c8ea2b8c6c79796669838c32adc4e651b6e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "186bd0cacf749f3291f22c83b16a756dc41062649e4ab733ab4c1cb92b0c9458"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "186bd0cacf749f3291f22c83b16a756dc41062649e4ab733ab4c1cb92b0c9458"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "186bd0cacf749f3291f22c83b16a756dc41062649e4ab733ab4c1cb92b0c9458"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "465bf9fd32b1f7b03cc2a82163e71f46557b83d463de2d0467c56da45cae571b"
    sha256 cellar: :any,                 x86_64_linux:      "87a0072bb98155e5e5c7f741971980bbf3420182d0d9b0e0800778b94aebe015"
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
