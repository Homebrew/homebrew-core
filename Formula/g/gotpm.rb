class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "9bc935311f2ad3c48763a0e1c77f777b9a8e3db696c7bfea99946ca2ea45fc6e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "930187e3e5837f74743d683cc103cdd3bd199d6e9bd6bbebebe742cf9b294b71"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1ea54bfff6542b961e3e5dd565fea80979fc92c98cdfe330610c7ba3430c099"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a49ea96a0bb71641b12bfccd051971e01dc76d1b8a7ef82aef69cf8dea549a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e15b8925ad71cb965d75495c69f961d1105a52b0e839ff9178f12d959405a08"
    sha256 cellar: :any_skip_relocation, ventura:        "897cc517ea218f776142e3e48471c6ceb6bc53013474c53ea47a9c1bd8f3975c"
    sha256 cellar: :any_skip_relocation, monterey:       "a7f6eae925bbbc1a2c3d0fb5fab33d9dcf1aeb63f8d4d3a36f9e91f21e8bb613"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7baa28852e4a91629bae235512db7cdb80c2dfbb55bc0e2cd769d6efb1b8b83f"
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
