class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "add24630e3259d00c69a0aadd5cd4f6d72496bcec161c5d4e64b738d4a6dd20c"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "65870be58c23282f5c11b5a1cfd2e42d5f7433ff79110a1ac7405ae835891143"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "65870be58c23282f5c11b5a1cfd2e42d5f7433ff79110a1ac7405ae835891143"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65870be58c23282f5c11b5a1cfd2e42d5f7433ff79110a1ac7405ae835891143"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b56f11b7fb65a2a4034e6bc8114823861081acf5ca1a11ae2849f25cd48965e"
    sha256 cellar: :any,                 x86_64_linux:      "b397e6b604e076324ed95411107a3c2af74517b4852ac914fe2c02c6a5d3a4cc"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/git-pkgs/brief.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"brief"), "./cmd/brief"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/brief -version")

    output = shell_output("#{bin}/brief https://github.com/Homebrew/brew")
    assert_match "license_type\": \"BSD-2-Clause\"", output
  end
end
