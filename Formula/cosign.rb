class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v1.12.1",
      revision: "0baa044bea61e7c16d56023be20ead3d9204b24a"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63f6d06218eaef81f17988ab8d703ea65c3c14cd976b5d5f33735c04d49cc10d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eb5d5e23fb056d22ec1f080b681596d4ec666a228c26c7eb4f4651f08e6ad4d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b13e0ccd162ee7a858c3ca93cf831664ce6e798ec23bc8d71c3135d35896fe6"
    sha256 cellar: :any_skip_relocation, big_sur:        "386b6de77b50ffe80fd6a0200bbe3a2620077d6e4d7bcfda07b7ebc76437113e"
    sha256 cellar: :any_skip_relocation, catalina:       "d26eb1f9dc0412ce93071eb7f0b939f730dbe89627e184d1c5c7071b13c81727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b4b3f910c85389816063dcbd8e4fac62df151a0e89ae4d46c9fc2fdca53358"
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
