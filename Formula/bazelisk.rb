class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.13.1",
      revision: "5387890d03c899417a9fbc270a7014c726d0f0dd"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d574d5392f3591846aae824ee7d2ee5a20fb3d1feee371967bffece27e2b18f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "012894f14f31ed70a3db288f52ec3b2c1f20533d13373171b874ce5579e6fcc6"
    sha256 cellar: :any_skip_relocation, monterey:       "d59c4064e0af2704a4d8eed3c42d13510973b784aa1812671e5a990e286ce8b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f522e9a8a6343ec60148071a13c00a4eb6c4ab45ba7f0285026e28744bac8a"
    sha256 cellar: :any_skip_relocation, catalina:       "181319801ff905d2a5bbc6b6c57ac291c043e9df838332015f214eee94927410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c9738e2a1911db7218eb8f52ba6e5e949d3bdfa402de96c0dd15681b8c34b10"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    assert_match "Build label: #{Formula["bazel"].version}", shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "4.1.0" : "4.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
