class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.9.0",
      revision: "a4cb262dc3d45a283a6a7513bb767a38a2d3f448"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb3ac5cfa25e5ba62c99811d074977dce14c8cd5762579aad6f8f80724548982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da4ec92c178dadd6a82d415bf5a957dd46dd2696aa1d54fb2cdc6fb3e3db2513"
    sha256 cellar: :any_skip_relocation, monterey:       "9b083b13ce9e2459ea8d4da7700caff16b218096954bf8cc4eec901f1b512a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8561ebe8a7c9b54c3ae9777975142e3e028572d4d6d9c2eb34012702c0832c47"
    sha256 cellar: :any_skip_relocation, catalina:       "2643d96626f5c83486197176a0f6bc3f08c5103106ece148233a2a75e996b12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe7ba1d7b6c748fb735a936e5a625cb251515d0e38a3b82f5093b96248e5d0b"
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
