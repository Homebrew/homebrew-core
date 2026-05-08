class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "b9fd80e4422ac4addf3dfb95ecb605652d109549a77cc420560945b5e9494e3a"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e9ffb728a3c1f3d146c16bf7ff979e9ebb6e9269eef9e8e859214e4e545becd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f890caae0a9cae4da5a523e1db9cd618c4b1345b8927be54c0fbe76966ff89d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82ff3f6fb780e259a0f97bd0748ec0f8fd9a3fdf93791e6a3254294c89b889e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8ce387f918af8e0a33947c7f1e0e627ef228c3b11300379b1398f442eb3f86f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b592a1735f91a93b908e6f2b1e67889df118da40a437dedddd2cfa0eebd2bfc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737747636007a685b43a28ca051172f443e9ffc737cfb9bee6c4703e140bd582"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
