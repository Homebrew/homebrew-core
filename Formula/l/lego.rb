class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.31.0.tar.gz"
  sha256 "e3504804193be4ab72ca9a40725b3632f204f20d92920a0e886250091e3dab6e"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0ceed15d4f61458feb4a45c6e445c6f43cec5a424d16562b6707b4d5e5429c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0ceed15d4f61458feb4a45c6e445c6f43cec5a424d16562b6707b4d5e5429c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0ceed15d4f61458feb4a45c6e445c6f43cec5a424d16562b6707b4d5e5429c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc2c5492dbe766abe0fb6b6975fcdb80f26a6da80fbcce09c7d65fd90c791282"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5aa71f8b3b4e076d9f8d9b88be9d0388e836eb9ca0a6586adbefd6ac3ea5fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "817f410af0581d11c0991dc33e7c6751b934fe12fc1ce30f4665e9d94cfafa40"
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
