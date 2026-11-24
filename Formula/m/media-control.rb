class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.9.0",
      revision: "507575ce288a9238372b7f39fde44988612700d4"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    manifest_sha256 "3340e6a4d1ef14017a63a8424001135864fde50f183d20e69ac2ca740f3b0283"
    sha256 cellar: :any, arm64_golden_gate: "56590a7995fad6ffba8cae044d18dae37853368526d6c35f61c6fcd40bf4805c"
    sha256 cellar: :any, arm64_tahoe:       "93aaf6b1e2e00459896aade73a91ade4469b26e01f89750834b303c648be9eb1"
    sha256 cellar: :any, arm64_sequoia:     "1553a6e39cd333e89a1403d8f61da7ee5ef38da900dc0dfa257d73449b02857f"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/media-control version")
    # `test` needs `mediaremoted`, which the `brew test` sandbox blocks, so only check the framework loads
    assert_equal "null", shell_output("#{bin}/media-control get").chomp
  end
end
