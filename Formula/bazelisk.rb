class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.12.0",
      revision: "40d8ae3b575950523ff42752e0c465a73af8d538"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d136dafdcb16343e95671fa9f4a9571248394b23bdfa507247b1fd0ce87f2764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a93f63cf228bf88659c00e477b73024e2413ec3ee2cdf39c3ccb8c3089501f43"
    sha256 cellar: :any_skip_relocation, monterey:       "2c6a6056cee9b9125c37a0a5c3288bf61cf4f39a0dab3a3214d5882a357c59fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d24ba023f7980d83a730d2c53b9917c69a521779a7aa899679b5a9e8ccdf672f"
    sha256 cellar: :any_skip_relocation, catalina:       "4a601d99f3222a5279132e9218eb1eae1c8b90750f90257f5409619d70e1ce13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f980dadb7506495e909514ca621356553c8e138e33048d10936f810535fbd6"
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
