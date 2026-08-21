class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "af297c5fffa4270b647405967500ba4c6531f611932e3a66e018e84ac2c33b40"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "491bb4f9d4c1ba2da2a9b3eb6046bc1b7eb3562ebda5a3bab4be38465eb44ae7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491bb4f9d4c1ba2da2a9b3eb6046bc1b7eb3562ebda5a3bab4be38465eb44ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491bb4f9d4c1ba2da2a9b3eb6046bc1b7eb3562ebda5a3bab4be38465eb44ae7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6420279014bc5716d3800c29ad00cea1ff12df72dc6f59264e0d90e48bfecc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6f730beb9a4c4b76dd72ac8edc4ed2c948989ff7ee0f1359876efb89783b94"
    sha256 cellar: :any,                 x86_64_linux:  "445cf192e322688b19e0031d3d42a2cdbcb3cc71f7f512deb7d3880d133c3e06"
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
