class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.5.0",
      revision: "38bb98697005cdc5c092f031594c0e45d039f4a0"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c2cd25f665ca8ea906e08475fc7094dc2dc32afd5a4ff365bf799dbbce99b21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f083bd5adc5e4c89eeee008732596380f7a0b123c42ee0e2fc8c4a394e175ee7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b4d94d0a5ad0ba7fb6d95bb7e5a53d16f3f27eaffb8789897ce38eb1cc59cbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "47f7ef1bb3b65d438baa796a1d69c825157b1ed1630b6d81f7ddd778b5f6708c"
    sha256 cellar: :any_skip_relocation, ventura:       "97766a8e480cd06913c1f46050ebc70a1a959715f34ea7705207a6f79b22a9b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ffc2c1d6c6a55de34709f44c0ed3ee01be183791535f34f164757d0a97f0d9"
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
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output(bin/"cosign version 2>&1")
  end
end
