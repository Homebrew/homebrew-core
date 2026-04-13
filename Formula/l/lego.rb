class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v4.33.0.tar.gz"
  sha256 "d57af04d6f5d0a018f19b099401fea093d4cc2efff177eaa45418b0046921175"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c4b0435e081fe63a8056fe5f0b1066e0ead43abbd4e394a9a6b60b9772051e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4b0435e081fe63a8056fe5f0b1066e0ead43abbd4e394a9a6b60b9772051e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4b0435e081fe63a8056fe5f0b1066e0ead43abbd4e394a9a6b60b9772051e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcbd67b3e51ee2089513793fcae269c33cc20ad8432d1a158ed023860404fc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45296ef673c73f0a3071b6faca2b1411fa989b3193424312075cb10eee60cb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95046ff4403b92649ac253d4949652bf4a2e503b7606686bf245b72aacca25f"
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
