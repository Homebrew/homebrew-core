class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.2.4",
      revision: "fb651b4ddd8176bd81756fca2d988dd8611f514d"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1781affbc88ced73cc9f5a351e489046b2345adde0b2edff66af52ef67636484"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d379b38a8dd30a9e70028686725cb7283653680ca5b527ba26a26a1a00c10180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d013da408ca107f4a219b0a16158cb7b10b9105eb23019c37e8f8aca8a839357"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd91cffbd0cf21b066d7048f5427e1743059c8245dfb90fc7e3586236cb3ed34"
    sha256 cellar: :any_skip_relocation, ventura:        "bfbeefcfee3a0b7e0c65167852084a7a0760f4928e4228a7c52ec74ab65d0b11"
    sha256 cellar: :any_skip_relocation, monterey:       "9f4611e06df84fc91e5966dfec801f1e887313bc85712b9367d64b1965bba3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f9a808588f464446c11a5f7d1f2c4b214604cc32db3d5148017fae8ebe25c6c"
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
