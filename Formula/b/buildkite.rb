class Buildkite < Formula
  desc "Work with Buildkite from the command-line"
  homepage "https://github.com/buildkite/cli"
  url "https://github.com/buildkite/cli/archive/refs/tags/v3.70.0.tar.gz"
  sha256 "52e1b708d08b0253252ae99245fc15462dd76986b4c05d6cb010592d8e498841"
  license "MIT"
  head "https://github.com/buildkite/cli.git", branch: "main"

  bottle do
    manifest_sha256 "1cf1d937b4c71cf60ab4896dea3da321d11ae19bad7d7f2765a657c09f23d1ae"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d78ddd8c004fe8bc0722efe677581c18492ee75eb9e4b463c6cde6b5afc4644"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d78ddd8c004fe8bc0722efe677581c18492ee75eb9e4b463c6cde6b5afc4644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d78ddd8c004fe8bc0722efe677581c18492ee75eb9e4b463c6cde6b5afc4644"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "59ef9dcec620a40d9c4e545531308c073b09191c64c98fe59d97facee232f7af"
    sha256 cellar: :any,                 x86_64_linux:      "563812cb4653ac26e7f1b5785ee48662a8055ae5679ad912a0d3d57a628fb48b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/buildkite/cli/v3/cmd/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buildkite --version")

    system bin/"buildkite", "config", "set", "output_format", "yaml", "--local"
    assert_equal "yaml", shell_output("#{bin}/buildkite config get output_format").strip
  end
end
