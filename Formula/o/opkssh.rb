class Opkssh < Formula
  desc "Enables SSH to be used with OpenID Connect"
  homepage "https://eprint.iacr.org/2023/296"
  url "https://github.com/openpubkey/opkssh/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "33f52bd71829a731782fef72acc4871477b0567f13d89fc1cef482d606a275f4"
  license "Apache-2.0"
  head "https://github.com/openpubkey/opkssh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75cd8f256c04f68eae4887d6cd7c76a6a34f5168f1345c67aadd1a5a286c3675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75cd8f256c04f68eae4887d6cd7c76a6a34f5168f1345c67aadd1a5a286c3675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75cd8f256c04f68eae4887d6cd7c76a6a34f5168f1345c67aadd1a5a286c3675"
    sha256 cellar: :any_skip_relocation, sonoma:        "b40cef57eaf2d9796186e37a3314356c1fe3d3e8dafe7927af39ca97f504fe14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb363eb5be7cd1f301ef7599681c2487138cdbba94c4138f5f763d54a3e4bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb41ada7d51db8265952374b9624627c1255c12fe152e3d7d4f81f66008085bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opkssh --version")

    output = shell_output("#{bin}/opkssh add brew brew brew 2>&1", 1)
    assert_match "Failed to add to policy", output
  end
end
