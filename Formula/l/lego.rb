class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.28.1.tar.gz"
  sha256 "d0a2d032a82d1ce2ee0b13a532725382b06d71fe35bd86f9f78d9989d3aa2816"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e19953b8def1407cdb498eac22ce53eff951401d3e94777ec9f695ffe96c2ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e19953b8def1407cdb498eac22ce53eff951401d3e94777ec9f695ffe96c2ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e19953b8def1407cdb498eac22ce53eff951401d3e94777ec9f695ffe96c2ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d8553702fcc577619734b3925b065ac6f39c816bc5d5d235ebcc1bd925acf8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b029995429a6c1bd794c6ae524e30d055a0c70acab4c320c205d99aef8d1f7c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "394f89b5f3aa4183c238df7a096c27433583ddde8a5d3b6ef00bd63b64bb5289"
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
