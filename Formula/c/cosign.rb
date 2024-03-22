class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.2.3",
      revision: "493e6e29e2ac830aaf05ec210b36d0a5a60c3b32"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "639b5a375f7ae1b12e7a7a89b18a77648ef9517ad42d16bdde762b9f8b9ef4fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "643bdc585e3a550878616b588f3bf3e28f1085d73084a3d40401d0b2de0d33bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c6873d280b4794e41e25a428a6ef7f97724e70c89e0ee60fa0a3f8be5385103"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b67e1bdb06c8a821aefcd323ccfe5baebe54d54791d20fb888c643d8a873487"
    sha256 cellar: :any_skip_relocation, ventura:        "502b6431886d4c79c549b8ea11cec219b32ff46637a8d77b1374294f4e1dce76"
    sha256 cellar: :any_skip_relocation, monterey:       "cee392242fe68f01a609d8f3512a58b6a4305e00eae17dfea1f2e231918db007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a13d30b0a153b37a49f3e7bda862b995c4b1080bc73c922256d3e1f7b5b2ee"
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
