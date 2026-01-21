class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v3.0.4",
      revision: "6832fba4928c1ad69400235bbc41212de5006176"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b58d7def58c8e35a1f9d747a6c92796477f81a2b1581b59b07493188336ef79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d194c04a530e9d9aeaf66240f68a6e9cc19352ae7d3b55389646494dfa0a30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c3205093631eea0ec7a052ad10462131b10f326d3f389cef9fb9d02289bcf81"
    sha256 cellar: :any_skip_relocation, sonoma:        "3075518722db2fea4067bbbb23e25e66f4b1f5a3a4139cc187d85539410ef38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e065ec75247aaab8c736d6bb6d4c5110833d720fbe7af1d33b5f03dde844be52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01e887d05b621ef4854c3d453d048466861d6b8cd34ef928f81d57a9f8bf299c"
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

    generate_completions_from_executable(bin/"cosign", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Private key written to cosign.key",
      pipe_output("#{bin}/cosign generate-key-pair 2>&1", "foo\nfoo\n")
    assert_path_exists testpath/"cosign.pub"

    assert_match version.to_s, shell_output("#{bin}/cosign version 2>&1")
  end
end
