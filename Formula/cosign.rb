class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.0.2",
      revision: "871448050b924a7946ebe47678f23aae09ef432d"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "679ba15004087e7077af88a66b1ce296dfce0eab827647cfbbc177a94aaba928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "679ba15004087e7077af88a66b1ce296dfce0eab827647cfbbc177a94aaba928"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48655cba87e82e74a372dba7c64caa84a476bd35e9e140afa6cf7ad51fb555c5"
    sha256 cellar: :any_skip_relocation, ventura:        "4f361fc6167b1f3553722c93cb45859755424e4b3e5ef5e4f50e6273015ce0d6"
    sha256 cellar: :any_skip_relocation, monterey:       "8badd24331fe7e7e9c2e714cff0252021ed6ba6606cafe9965712c5ebc89ab61"
    sha256 cellar: :any_skip_relocation, big_sur:        "c051b56c52205b3ab8412bb05501d12d0f82c869a08f39a432b1de4b697bf532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34428e1e58028db163184eb6818d18b2ebc5d777a3e1611f4a96f89042e12309"
  end

  depends_on "go" => :build

  def install
    pkg = "sigs.k8s.io/release-utils/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.gitVersion=#{version}
      -X #{pkg}.gitCommit=#{Utils.git_head}
      -X #{pkg}.gitTreeState="clean"
      -X #{pkg}.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
