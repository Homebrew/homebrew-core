class Gitsign < Formula
  desc "Keyless Git signing using Sigstore"
  homepage "https://github.com/sigstore/gitsign"
  url "https://github.com/sigstore/gitsign/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "98aae793562337414bc67d529eb2971efa6168020fa4640634b8942faf9a6ea9"
  license "Apache-2.0"
  head "https://github.com/sigstore/gitsign.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a54bf87aa0e1d92363eb5eaf1c985342dda65edb18cc491437f3b8fe6c67ea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a54bf87aa0e1d92363eb5eaf1c985342dda65edb18cc491437f3b8fe6c67ea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a54bf87aa0e1d92363eb5eaf1c985342dda65edb18cc491437f3b8fe6c67ea0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a360dda6c07f8435ea9887a7ddbcc7e08ff507908852d210113b930cfdaf528d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b3eaa45137ae08fe25ebb56ceab6ac4f713fd6e61f1b08b721956675c31783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a98a432d4c92090be7c42cebee6f6468f2ae77edb5a931832875aaf1063d78b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/sigstore/gitsign/pkg/version.gitVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "go", "build", *std_go_args(ldflags:, output: bin/"gitsign-credential-cache"),
      "./cmd/gitsign-credential-cache"

    generate_completions_from_executable(bin/"gitsign", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsign --version")

    system "git", "clone", "https://github.com/sigstore/gitsign.git"
    cd testpath/"gitsign" do
      require "pty"
      stdout, _stdin, _pid = PTY.spawn("#{bin}/gitsign attest")
      assert_match "Generating ephemeral keys...", stdout.readline
    end
  end
end
