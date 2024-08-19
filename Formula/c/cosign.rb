class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.4.0",
      revision: "b5e7dc123a272080f4af4554054797296271e902"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ab71e2206823bbc2f2571e5effe987cc129f984a71249efedcf2e76db97434e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1a823258ce0456f64ed02fff022232cc892a02aebe97ac4c110f6eddce8b0e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb3cc3863e86d5292dee1da73db379e83e95d1ae1b336b33f5aa92c89200390"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f76f04c1031006cfcc4283cbd28ac6ec90f45529a67eca2772d849756948dae"
    sha256 cellar: :any_skip_relocation, ventura:        "5033f1ad1eb8747e7ad1902b311e6085a60a033e89b872d56a697457fe57ede3"
    sha256 cellar: :any_skip_relocation, monterey:       "56b6c51b961c78cff63255124bd961b6d2fbfa0efaf8dd0287ec1f500d5a54cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03cad6708d69dcca8c348b45934f3931387937dd35ef1577788a023fc0d63856"
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

    system "go", "build", *std_go_args(ldflags:), "./cmd/cosign"

    generate_completions_from_executable(bin/"cosign", "completion")
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
