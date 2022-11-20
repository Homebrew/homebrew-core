class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.13.1",
      revision: "d1c6336475b4be26bb7fb52d97f56ea0a1767f9f"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a95a4be1c732ac741969d5ffb6b14017e7514bab86d77bfb854c5cfc9cd5e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ca0876a726924416a09a548a9cd5f59a30f62796eaf94659082d163487068a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56144ede6687b63e90ebad77ff3889a2ff421672ba1c8c6f7ed0a5fb10b2ca69"
    sha256 cellar: :any_skip_relocation, ventura:        "a61dcda531be2dd019df2375a65b0815d652144147877274ea471cdd2e212066"
    sha256 cellar: :any_skip_relocation, monterey:       "45e42f866150ac981dad74171aeabc6497c30c81098efec258bb644e65bbf8bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc74eb0310a7751ce9e2694a36831a032a4cc0af89bff9614635e5c9dedb42b7"
    sha256 cellar: :any_skip_relocation, catalina:       "0ca487e247a593b7c89730c6db1992581ebb25bf745cd47d8579acdcaa218d16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe9ccc27799e1b0e7e2f9407a4821978aad69abaff58a3dde25ae2b69d94bcb6"
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
