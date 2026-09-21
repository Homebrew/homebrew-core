class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://github.com/appwrite/sdk-for-cli/archive/refs/tags/27.3.0.tar.gz"
  sha256 "363950af2290b149d5ea376e1f7dd202d61a3a38f3b536bb2fcefd515a1c9a57"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd0c8a4785bb6944364a965ef3c15987c859c18e0d80dccc559d3c5cf4aeca51"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd0c8a4785bb6944364a965ef3c15987c859c18e0d80dccc559d3c5cf4aeca51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd0c8a4785bb6944364a965ef3c15987c859c18e0d80dccc559d3c5cf4aeca51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bd0c8a4785bb6944364a965ef3c15987c859c18e0d80dccc559d3c5cf4aeca51"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a04abd5e78b12d6d40ab45fb69872059e3f10df2f10f13478daec3c9cdbffc8"
    sha256 cellar: :any,                 x86_64_linux:      "0a334eda8cd171ea41f0a2b7336080b5ec8f1450495b6e2fb30d6154cd1a24fa"
  end

  depends_on "go" => :build

  def install
    # https://github.com/appwrite/sdk-for-cli/blob/4399a3321898f40cf982acbd4859d506c9d4d9f4/.goreleaser.yaml#L19-L22
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-X github.com/appwrite/sdk-for-cli/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"appwrite", "completion")
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end
