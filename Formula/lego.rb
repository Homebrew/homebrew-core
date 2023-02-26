class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.10.2.tar.gz"
  sha256 "8d494a03b17b5d8e8738f59ce4041da97c50f503ef039fd02e7a8f40af3006d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cae9b9574119fa5ce634caf42662280829c73c451bdffde3e790821efb0f2b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c52cc4dfd56e9cbd41ddd3f554e298739a4522055525995f27d98b69af73297"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24c7091f9790b7d7c35b1691021f25dd669512bfd6188246cd745a3a86478e27"
    sha256 cellar: :any_skip_relocation, ventura:        "b184869f34a20619b5139c89e5e7d2e3a16b43f8fea0f65d52d62b48f7f3f850"
    sha256 cellar: :any_skip_relocation, monterey:       "bc0d1f6d9563fdbbc156a2aafa3001522b606e369f9e369093cbfdada53f7905"
    sha256 cellar: :any_skip_relocation, big_sur:        "70b72d4992558fdde3741a95cf46fe2e14aae074b23a89fa548c3ebc53ae243c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83ab2d0eded06aa1a1504d6a8944d0794b57e5560b4d9898521f103d4b2ac1b8"
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
