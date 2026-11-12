class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.22.4.tar.gz"
  sha256 "4eddbf690f65d6ca440fa8c1f2ce2a3439070cdf5d42c7aa8669a9e1552fbd59"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62b0ec9ff4354c15f0e3042206f3b90c30768650cb9288df72ec04319b40084a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5eac4e481dfb14aac7f0b7d44e3bac37e78507786c59526004cfd42cf6819bc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d506f9d20674dcb2c948ba2e8829dcfb3433867505e404389cdd0bfda9afd3d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eca39d7a2721368876b8b92b0a83a8463991b7ceecba8e865b2e4bc3a2d23219"
    sha256 cellar: :any,                 x86_64_linux:      "faebb5eaf1b14f9c2b24cccdc0f2cb88583cdc131ae6b6d130c6bf7570d51507"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
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
