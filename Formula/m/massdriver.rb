class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/2.2.0.tar.gz"
  sha256 "04fc9768ecde6353f118f2295eb5ca05ba4a01f4464ac4cc1200f9b0b1eaffb0"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "822225fa8e048c3d7aa1d94cc4e0935ab70557a7a1f9cf3e39b8af117676db2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "822225fa8e048c3d7aa1d94cc4e0935ab70557a7a1f9cf3e39b8af117676db2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "822225fa8e048c3d7aa1d94cc4e0935ab70557a7a1f9cf3e39b8af117676db2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab4af0e667711075c145bd04bf0b7dae94954de902ccd5a13eb82d8a4217ef66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9332010f4b60b7f0f6b50e600c700dbb0e28695f35fc006b966b203ddaaae73c"
    sha256 cellar: :any,                 x86_64_linux:  "cf4f74bc01f9ac62daaf2579760781c10cde1b259593f39a73ce93fa95f5a9c7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/internal/version.version=#{version}
      -X github.com/massdriver-cloud/mass/internal/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
