class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "2b02bc748c0e579911de06bbfaaf5a48d99a21bd39b1172cea0557cd309ab40e"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d1a03aff56a0ccc4cd88b51dd98addb93b56bfbb08a2ea78c5f69f1da2dc14f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d1a03aff56a0ccc4cd88b51dd98addb93b56bfbb08a2ea78c5f69f1da2dc14f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d1a03aff56a0ccc4cd88b51dd98addb93b56bfbb08a2ea78c5f69f1da2dc14f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbbb360dc8e2b14aefecbb317830ad694cc8d7aaac34d9defc660311b038f784"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4868c1cd5540ae182dda21a39baf5245d5172d27562cc755e7db043c43e20c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "235c5a1458fc87042665a765ef4bf66d7e4f4a5cbd9129f37c311b5f485c6efa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gotpm"
    generate_completions_from_executable(bin/"gotpm", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/gotpm attest 2>&1", 1)
    assert_match "Error: connecting to TPM: stat /dev/tpm0: no such file or directory", output
  end
end
