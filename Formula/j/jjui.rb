class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "d0bcace1a7ace6c4690bcb314ddee37d0612192ef658d8ec30bd4f826d98f170"
  license "MIT"

  bottle do
    manifest_sha256 "012e3c09912ee8f19c45ac3cab58970cc1f639f9ff836db0ee1f325e8d055fa9"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23d6b6e4ec3b0b6d5d25527ed959e78616e33630f7dabee9598c7e1496f7e467"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23d6b6e4ec3b0b6d5d25527ed959e78616e33630f7dabee9598c7e1496f7e467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23d6b6e4ec3b0b6d5d25527ed959e78616e33630f7dabee9598c7e1496f7e467"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d389dc320b71d0f5f09cb3968ba4c27ff628ed7b2b9a1ddeea95bcaa1400122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "77bf8d7df344a8e4114365d145e7377f0305362354eb620f9980cb83bd49af45"
  end

  depends_on "go" => :build
  depends_on "jj"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
