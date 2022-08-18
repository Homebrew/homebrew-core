class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.11.0",
      revision: "6bfac1a470492d8964778b1b8c41e0056bf5dbdd"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be3ae127062ba1e5f23421ebd445ff101e3cbaf89e6ada1eb1089aeedd9d3f75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3236e0345de2296a23221a8201739ecb4a542134171766b4206bcd7c36a950b5"
    sha256 cellar: :any_skip_relocation, monterey:       "bf98340a24d8416400794fc2fa6d42c2edecc65afe7d839a0f98d38e8b469133"
    sha256 cellar: :any_skip_relocation, big_sur:        "185c25eb3e1936bd5b23e18880ccd431506a7d3c8e04e77c4a9cc625155b9e9c"
    sha256 cellar: :any_skip_relocation, catalina:       "1fb52319f1fbca7681cd8214a6d41a59cb741d603c275ea4588576ae1e380aa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56d69fb48ffb8f0bd1dbd8d18ac267259af05719ba561922f8d70475cb763561"
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
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_predicate testpath/"cosign.pub", :exist?

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
