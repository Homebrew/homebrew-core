class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.4.1",
      revision: "9a4cfe1aae777984c07ce373d97a65428bbff734"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8bb46b58ddc1624f80d26e9da4fa96ead1fa24b71e30a64615fe3ddf596f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8bb46b58ddc1624f80d26e9da4fa96ead1fa24b71e30a64615fe3ddf596f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f8bb46b58ddc1624f80d26e9da4fa96ead1fa24b71e30a64615fe3ddf596f7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e448c682821ed03a899715868c752045abee38bb0f87d084d84e59ca9a93fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "502cca6ebec6a5afd4f3089b536695705fbbd34bfcc92cc891016297e544bfe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fcf376637fb49a9d34bf7fee31180809fe211edb78793c0d504e6b59bd7ea2a"
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
