class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.35.1.tar.gz"
  sha256 "50a3246798c8808b7d4d78b3141d18d41363d413880ee8d663cbfa3efdde0640"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca525b6b74a0d6e90e2837bd2e876aafe16ada4697b615d5414dc23a0f72b12e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca525b6b74a0d6e90e2837bd2e876aafe16ada4697b615d5414dc23a0f72b12e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca525b6b74a0d6e90e2837bd2e876aafe16ada4697b615d5414dc23a0f72b12e"
    sha256 cellar: :any_skip_relocation, sonoma:        "41940e9e0a9c901f287b248db134154a251accf1a446cbe2e41ec0eb4e0ef5d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcde88395524aacca967a3224d8c6b3b3210bc1f27134b037acc9518f6921380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285dd85b08030fa0d3986991f0ba9bfbc08c8466472c0fdaf1a731723fa9dea0"
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
