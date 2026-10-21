class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "e01028fc5bc79a49b76b0804325ea5b12796c3275799f82b89e4cc0717bc3bb5"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "42e1d008eaf9c58e0d52e0080daf2a03a03b8a270409ed986d6119621e4572e9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42e1d008eaf9c58e0d52e0080daf2a03a03b8a270409ed986d6119621e4572e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "42e1d008eaf9c58e0d52e0080daf2a03a03b8a270409ed986d6119621e4572e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "beaeb927b1e0a74da25dd10874a5589930a1292d0ed7c7c6169ef0cafe194d05"
    sha256 cellar: :any,                 x86_64_linux:      "138c8219786b237c6b7ab293ccc67a9c9235a4bddd6818aa326f91a3d4b278f3"
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
