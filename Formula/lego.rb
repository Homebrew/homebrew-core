class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.5.3.tar.gz"
  sha256 "82778a122e98225b55e1e6c102a06948747263533d88284216f0cce238b897c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06c5282f510d060d9b9c209d7e34aaba3d7003d36b0ad9876c5968aa5065aa39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b390230208cb901698f134fa8d17209863b665b8b06155de9b858e5f68ea8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a3cf1942ac769fb3d5884cf0318ef28edd583712251ec281699248a4a52c424a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1a51477380a955c9e0c7e7f8302a6d224d8ba099ccadfcd502a998e7a2cdc65"
    sha256 cellar: :any_skip_relocation, catalina:       "8ea6c8c495023bd3eeda17208afa4f16bfbc869e142975942e6c59afaf37e6c9"
    sha256 cellar: :any_skip_relocation, mojave:         "d2396922556bc444386b8deffa50097a26ac7e83a4eeed5cb0e505b25ec0069f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6ed7dfc213ad51d356008f1e2f3e7caa048bbb78d5bd09690a31d8543876f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
