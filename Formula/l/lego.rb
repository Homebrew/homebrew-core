class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.5.2.tar.gz"
  sha256 "5e0ead0ff177a3f896136817842a420eadc55cccaab9d3afe957b05506f17d27"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edaa7f90b39d0544963b77e843f7b7594c51508e70b5bf84626d08a71c0b45e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "edaa7f90b39d0544963b77e843f7b7594c51508e70b5bf84626d08a71c0b45e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edaa7f90b39d0544963b77e843f7b7594c51508e70b5bf84626d08a71c0b45e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "642c26236e9177220fadfac5a4f8c2b6b799467a3a710efc9fe84415d1dad5f5"
    sha256 cellar: :any,                 x86_64_linux:      "76f7bfef96896d302fb21aad0273b135ebec5a0a1700ecb8a83598e961dd87e1"
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
