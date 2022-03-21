class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "aac002d8a89b0b4a3d4ae3f7e78b4b9ae9cdba903174ecc972a30a31bb2fe940"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08b58a3f0a4cde592d77be710fe1edbd2f4b9158f5aa7c73170378e36dc8c269"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3609644761d5ddb74b84b437f7cec17faf97bbc4e5fcce3123a6a29645637fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "023ed729a3eca3e85210af7b6a1d7cf4c97be1ed7839a8443bc42d3bbb149816"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a782e75179c917d185c794b02e21b19914fbdc7526960ba4a62b16d2d66ac4b"
    sha256 cellar: :any_skip_relocation, catalina:       "d5102b0adebefd0b3198107a6abdd07e5f814f709840477cafff6f7c82310a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd28af1808d2f61b528f89f27e830475bd042420d17e8491e558ff792022a50"
  end

  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
