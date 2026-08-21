class GitPkgsBrief < Formula
  desc "Tool that detects and reports a project's toolchain, configuration, and more"
  homepage "https://github.com/git-pkgs/brief"
  url "https://github.com/git-pkgs/brief/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "cabe07ba8e0d01976128fdeace71c55d1d85f0e865571e4044bbc0b82b72a071"
  license "MIT"
  head "https://github.com/git-pkgs/brief.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b74bd13113533d82beb61725bd65b4a66177e75f138715a84b54ccafba819bff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74bd13113533d82beb61725bd65b4a66177e75f138715a84b54ccafba819bff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b74bd13113533d82beb61725bd65b4a66177e75f138715a84b54ccafba819bff"
    sha256 cellar: :any_skip_relocation, sonoma:        "937350d8974740704cd4a9af5500b3c83177163db0de500a98d1c231867dff4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b58f4090bbc260761a1d03873a0b935cc6d15c5c2f0c7f3346fac2fdf54629e"
    sha256 cellar: :any,                 x86_64_linux:  "df6957a809a3db4b15cf06e1d8d7afab976642fff950b728f2c53d9f36478591"
  end

  depends_on "go" => :build

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
