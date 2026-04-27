class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.35.2.tar.gz"
  sha256 "0afa5397dff24643ab34773518063432ed939788435a16305c92f2090a899c3b"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "afd414187a9bb43afe9ced193d367d8bb1ca67279056aed5d1702461e5763ccd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd414187a9bb43afe9ced193d367d8bb1ca67279056aed5d1702461e5763ccd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afd414187a9bb43afe9ced193d367d8bb1ca67279056aed5d1702461e5763ccd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f12c88d53f8098b305d89dddff8dd5d35bd51b4acbb1faacb7f03a41ec3c2d09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de64fe18c2ffad63023bcf5673ad84c08d2c9e7ec3b24b87d65a4c6cdbf7728e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ebada5b08bdcf4c24f51795837b2b38e6bc44e57d85d18f2d91910d50a96eb"
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
