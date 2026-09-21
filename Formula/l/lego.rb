class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "9735d946aa00522764d08fb56c1483f2da42f0ebd0bc1eebffc35e4b89c289ee"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1d4507191781fe531b0be7686a79e1d11174f2d49fd4bdbfa6e21f2b75a11ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1d4507191781fe531b0be7686a79e1d11174f2d49fd4bdbfa6e21f2b75a11ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1d4507191781fe531b0be7686a79e1d11174f2d49fd4bdbfa6e21f2b75a11ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "98546f7b25fbf6be8ca2f16d1cc59dd7efe94eaa8e1f575695d4812375dca8e7"
    sha256 cellar: :any,                 x86_64_linux:      "c4fdde491ad549ffb4d2a334c2a17ce7ed8e762a1cf6ec4bda8045f77603c549"
  end

  depends_on "go" => :build

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
