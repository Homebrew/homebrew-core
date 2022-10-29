class Ctlptl < Formula
  desc "Making local Kubernetes clusters fun and easy to set up"
  homepage "https://github.com/tilt-dev/ctlptl"
  url "https://github.com/tilt-dev/ctlptl/archive/v0.8.11.tar.gz"
  sha256 "577f58c7d136015a813b033b240c9b28d905ea3f68c9afd1e1e345722e9c7053"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3738447e8bc471c6e39ca57a300bd1c39f79e92a1e6a31a93af119c24126772c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b70e4c257abb2de7f77a44c4ff464ea84c8e416a53904729e829fe4f393f3a2"
    sha256 cellar: :any_skip_relocation, monterey:       "60ff67dbc0b3bb7383411a211073a51f38c893d897aac74c1675114ac52b5cfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03d078ca4e19844cc5236b06cbb8256586629d6311014286b94569be3fd9449"
    sha256 cellar: :any_skip_relocation, catalina:       "72c9b051bce7565da74da7d96581c112004a0ace5ff1eae97b8a09d96721ebb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0abe6211d28596e6c5590da7e7e7a44184670d23ab255ee4915b2d24711256"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/ctlptl"

    generate_completions_from_executable(bin/"ctlptl", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/ctlptl version")
    assert_equal "", shell_output("#{bin}/ctlptl get")
    assert_match "not found", shell_output("#{bin}/ctlptl delete cluster nonexistent 2>&1", 1)
  end
end
