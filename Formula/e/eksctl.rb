class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/eksctl-io/eksctl.git",
      tag:      "v0.228.0",
      revision: "ab26c5b38e42a8143f9f110c1ba4bf745ba07d5e"
  license "Apache-2.0"
  head "https://github.com/eksctl-io/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "485ad626309652c860ff6880679cd1be66924b450e61b8055944c711f86002da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7000a58d71d9a14759b0fead31820d503702f0701f262b25658cc7582a2ac80f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adaaf1c7e1c3669e9320401f7999b3b2fca1e9e70f97fa4854662319b8f0df7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "29e4829c6a277b2b992f24ac360dd2c0d11286260dd5a0a2bfad676cfe29fdfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff3581b696be83f94b47cbd69047a5f9079a3ac94ba6d37d5d7931d06e242ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc1cea9ee1814a9c64e68e753d3b1dfb98725da121568accc89e51dd8472559b"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
