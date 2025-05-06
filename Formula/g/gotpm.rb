class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "f5cf18c21b985d81a6c96c027723e755c70004f4b6d14b9223b38183ad6f68f5"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f377258aa46e54eebae48c3ff7d7cac5a9105b1009a55b95702fbb616788bfe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f377258aa46e54eebae48c3ff7d7cac5a9105b1009a55b95702fbb616788bfe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f377258aa46e54eebae48c3ff7d7cac5a9105b1009a55b95702fbb616788bfe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "507a381691ce87d722acf27cc06882ad5b2df0a79b0fde6f208c0563f4252f74"
    sha256 cellar: :any_skip_relocation, ventura:       "08265b9d272df524116378165237a3618ff97e45109095f44a49faec84d48738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e259dee95de5a7f385d8bc2769cbc0611ecee1d311068ff1cd3ff8fbfb2b3bc"
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
