class Cosign < Formula
  desc "Container Signing"
  homepage "https://github.com/sigstore/cosign"
  url "https://github.com/sigstore/cosign.git",
      tag:      "v2.5.2",
      revision: "af5a988bb15a03919ccaac7a2ddcad7a9d006f38"
  license "Apache-2.0"
  head "https://github.com/sigstore/cosign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988359d45c8ad533a3e6c9f7c00b7856b704c96d7f38b16ce83d6b364de360ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af34efab53781dbf6eadef610069aeb4ef9480e5e5fa53c0b9a40e381b9a6a13"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e26f9c707de569dff4d7f1a08bc23ac40aa739ec45b644d9ff8a4c0b7b321ac1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0def8d3dd6e2ae916670ac19961746889fa205b6f72f65344fa874eaef1a7078"
    sha256 cellar: :any_skip_relocation, ventura:       "d1a4ac45938e19af82aa2f94fd45da60a6cb18a841281a82d851366b19edc69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6e51dca398ba373a15f1d27ecb93cd7d4e6980b091e6132409a0e80d5dda800"
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
