class Gotpm < Formula
  desc "CLI for using TPM 2.0"
  homepage "https://github.com/google/go-tpm-tools"
  url "https://github.com/google/go-tpm-tools/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "a2eb3739afa65b60c351550c6c0541f17c5af6a22837da3690fcd6e44ef354bf"
  license "Apache-2.0"
  head "https://github.com/google/go-tpm-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67ce1f4f112a053eb9f48a7e69f9e6a8f4bdc01623278c9d22b6718800ee873c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67ce1f4f112a053eb9f48a7e69f9e6a8f4bdc01623278c9d22b6718800ee873c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67ce1f4f112a053eb9f48a7e69f9e6a8f4bdc01623278c9d22b6718800ee873c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfbbf0aa121c637637d574d21de8026dd59c064e1566332d9478621b0905130f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb9d36fafbf498e1210f46a970a2de664c3ca7f65dd7b63770be78379e06e76"
    sha256 cellar: :any,                 x86_64_linux:  "bc081fe93f7e79ac5a6c3795f3b847a3dd3e8b508cb45631206c189dfc75e172"
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
