class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.21.0.tar.gz"
  sha256 "21204483e62bff3e762583e42044183dbe6efe6b401772bb186be821501d9463"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22a130780af1ae4102daeb202ed9b06df799d8fba4ee24595709f6a3e928471f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22a130780af1ae4102daeb202ed9b06df799d8fba4ee24595709f6a3e928471f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "22a130780af1ae4102daeb202ed9b06df799d8fba4ee24595709f6a3e928471f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e4935c9943b0b018fa7835873f9d3ebb592de50fee14302580e75117de92263"
    sha256 cellar: :any_skip_relocation, ventura:       "9e4935c9943b0b018fa7835873f9d3ebb592de50fee14302580e75117de92263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "728dfd9eca049126a1d3b30e9cf78360b8c1721951c3272f01a98b7f87e647d7"
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
