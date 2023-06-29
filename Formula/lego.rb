class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.12.3.tar.gz"
  sha256 "9c602d7fd33d424fc32c5581d95361c51abab0f44d03552eab5dc13af11756c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "757210487b4ca26e04ab732c8ba63a5f3556a6a6837ee927720a762efb8f0684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "757210487b4ca26e04ab732c8ba63a5f3556a6a6837ee927720a762efb8f0684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "757210487b4ca26e04ab732c8ba63a5f3556a6a6837ee927720a762efb8f0684"
    sha256 cellar: :any_skip_relocation, ventura:        "81fd9e88ac50678c6abb025d6378b7aeb4fcb238b7b0819965a84beb7e13f46c"
    sha256 cellar: :any_skip_relocation, monterey:       "81fd9e88ac50678c6abb025d6378b7aeb4fcb238b7b0819965a84beb7e13f46c"
    sha256 cellar: :any_skip_relocation, big_sur:        "81fd9e88ac50678c6abb025d6378b7aeb4fcb238b7b0819965a84beb7e13f46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8868fbb525cf98a683bb570ac8e7ab7fe4cd4055154bf5ebca1e4c195a383b8"
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
