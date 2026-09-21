class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://github.com/amir20/dtop/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "e0f5c86a41bd337b4572695ee8dbad2e146a6d61471ca0d12007cb93b3d2d229"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6077924a277e699679dade43414a0d5d275a896e5a98c06333b75e612d233af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cdaec585aec9ee28c9c3917f3a3e6cdc3bf90ad32e20c2f822f3e18c90dc1dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d94d8c30a64540c8ae34b1a99006b680efce37e1555ed7975309875eabccffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1b64df51b15ded36bdc795d02f6f5267168af26962334ec70006416bdfd91950"
    sha256 cellar: :any,                 arm64_linux:       "4e75a2f154853cc72adfe15444291cfa7c7b28f6a43ebf871ddf29a9fa8478eb"
    sha256 cellar: :any,                 x86_64_linux:      "fd498cab959ce4bf1b66ed7370ad86e3b7dc5cc4fa7b68504342355726e750ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end
