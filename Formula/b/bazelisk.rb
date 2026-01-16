class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "f9cde570efb98f0b607c4caed6bfe393252ef8a24f83f5ca549b48d3aeab3c64"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e67ccff1f222064f33beb522f97340a3f689a038ae80eec3e9cdd250f1d11e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67ccff1f222064f33beb522f97340a3f689a038ae80eec3e9cdd250f1d11e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e67ccff1f222064f33beb522f97340a3f689a038ae80eec3e9cdd250f1d11e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d073e1a77ecd0895e02909d0687785e4a6f15292c459a60f0c78e43b07354c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59a44e5cd50fb1689ac76d9ae9869c423136a637d1f88ccb6676df7d0a6e1b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2c15a3f460a7eb491b19ce7e26dfaa310a9f2bfab3aedd41212ed3df3ab73c0"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = system_version = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{system_version}", output

    # Test an older version that bazelisk will fetch
    ENV["USE_BAZEL_VERSION"] = fetched_version = "7.6.1"
    assert_match "Build label: #{fetched_version}", shell_output("#{bin}/bazelisk version")
  end
end
