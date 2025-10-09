class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "ee66c33b2da562c73fd353ca1c835eeae73f6ca62084bacdd31c5fab4dfa7c72"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce8c67811882e10423554d3ababfae799b1cf51dd5d6b79e91f9d882804e48cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8c67811882e10423554d3ababfae799b1cf51dd5d6b79e91f9d882804e48cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce8c67811882e10423554d3ababfae799b1cf51dd5d6b79e91f9d882804e48cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "96c81a11e82f78dfa9e3dfd44f2df05e00e2bd1bf2af54f4190a3b92214e8dd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "602666be69f955a4a8c38e13b909575692b83988da4d0f16d0d75cd3d9ff84eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31df5aa71e0a8e8208510e57539b2b6f4dc42e8938f5ed965687758b788ee291"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gotpm"
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
