class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.26.0.tar.gz"
  sha256 "31b01627ff6e40aa8a8955b68a95ee7be9c10297faed86a5528734b9a9edd981"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2629d5f9d75920e360c9e7fcde01e2d3b5e58e79a1f0201899287aee757339d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2629d5f9d75920e360c9e7fcde01e2d3b5e58e79a1f0201899287aee757339d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2629d5f9d75920e360c9e7fcde01e2d3b5e58e79a1f0201899287aee757339d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a553f8a16290638f8446cd839e9ae23875f4d8a75f857e2d1221958cb82b28b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "094c9f054cd2c49d28a7ade8d2df340f596ef130c7cf73d3be633d98e004d199"
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
