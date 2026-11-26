class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "120cf04576f21aa41232914031d1cddb87b6879c7fb9c062a1a163c23a8431cf"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    manifest_sha256 "21fc30cc2ff25058cf880297b1b42a5bd9829c4c1b840414053233882187a8d6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "45c20535b64a72de53f11075d47738606d0b9e0daf065c18eac7cbb402ccd145"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "167e85d570fe0fa1bbbae69d2863ad423ba2c754e4be626cb1903f667a8ff52b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "03cf2fd350ae6054aa0d1296bdb6fdbbbe6b610617d4e401b7b2fc3049c86dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4b8adb575f8b4a09fe24f142c665044caf7c064038ca3847517b8acad4b7a6b"
    sha256 cellar: :any,                 x86_64_linux:      "a47dde010d516362d268c6be1deaf0e204905621d3e3204e6460c47228ef00a5"
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
