class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "90432420aebe2bfd69fe0180562196861416eec3277d5bd96c5789a8876a6411"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "378a5d1849cb4b133ad8c4b0c3b69200b44283c6f5f244af34c94cd5e4675754"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0524daad75bd44d299122c0ef4fcdb56039f5918dbcdcb4f158f0ee4afa0c081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68993952d33afe728d3f429ed6be74d34ee430ce3dcc7b105ee4d2930cc788d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "86e1417b0b2eb1e18adea36b98ab4d40c3d9d6f4d528cf5a7806c674ada52a8b"
    sha256 cellar: :any_skip_relocation, ventura:        "e1dfb10b2bc2b39e431e8164ee662f4ab194faf934913f77acccb2894aa4c1e5"
    sha256 cellar: :any_skip_relocation, monterey:       "91d9cb2706f2433bc5d49395ba481db5ebe40e0566e13efaf378641d7851eee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e6cf242f0b2e2f40710de7a98cf7b56745b004aeb39c62410fef84c8532db8"
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
