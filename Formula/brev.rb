class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.77.tar.gz"
  sha256 "95928fbbe9fe8fe25e14207a4cc17444c70d3c430acee9a420f8afc6d3aad502"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27851f74ae352f547f8c49c517945c69097291aec8fc350c1c5900ffa32de93b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a974eb445a7af726039626a1939d590f4e4ae17e0d68435a88089ad4ec4cde1"
    sha256 cellar: :any_skip_relocation, monterey:       "23aa40be7cfd77ff28480e8e9b0f191d4fff096228f09e151d49022766fc3087"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a125e176d73c39e7684c06ae5c2f1cfdb9d0b936ce9fc9a5404231fc5f53325"
    sha256 cellar: :any_skip_relocation, catalina:       "d0737bd5a2ad2d01fa0615c7d06fc5d473b29fa5fb5f83958f67700d65a0dd70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcc17637e91ce62443f480e67450e29f2c177ae2e08f8e2ec775cd30b3d58d27"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
