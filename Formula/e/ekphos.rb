class Ekphos < Formula
  desc "Terminal-based markdown research tool inspired by Obsidian"
  homepage "https://ekphos.netlify.app/docs"
  url "https://github.com/hanebox/ekphos/archive/refs/tags/v0.25.10.tar.gz"
  sha256 "0f88f0555d1d453458d35fad5779b824288857e95ac039605ac1901733fe044b"
  license "MIT"
  head "https://github.com/hanebox/ekphos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3ba9674592fbfc527b7cd204c9cc1dc8575cc02304664c85b82b23806f6ab04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c80a7ab6c5f12ce04accee0cdea02c40788e51ee84146b078c37316ca6dec1eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a651010eafcd57fd2e08a65d2e0fd6cb273c5ae2dfa681aac00af9b85aec8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fee19795d599090fe107827f628744b48c0ae67f08770ef7a4d1ffc005f424f6"
    sha256 cellar: :any,                 arm64_linux:   "7b808c61a48038f5beb84c96a87f01ad8289ffff6c7025c13bf4652082b52488"
    sha256 cellar: :any,                 x86_64_linux:  "110ec970c010a9c74a78f16400a82136a879d8424b6a0f5791520bf4fae9bff2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # ekphos is a TUI application
    assert_match version.to_s, shell_output("#{bin}/ekphos --version")

    assert_match "Resetting ekphos configuration...", shell_output("#{bin}/ekphos --reset")
  end
end
