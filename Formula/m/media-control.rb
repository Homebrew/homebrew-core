class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.9.1",
      revision: "b80ad0489268cdd9cc47b00410e133e5efcec49b"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    manifest_sha256 "4e3d6e033d4c19a0675da12284b4d4d82bb9cbad910115f4ba19efea3c6cc357"
    sha256 cellar: :any, arm64_golden_gate: "15d8d463bfb11c304e4dc52dfc23019077c8dfa65318cc8332d83f6457d58a59"
    sha256 cellar: :any, arm64_tahoe:       "f89184ccb3585b3558fda4f14d35a31041917cfc6fd7d83ba1f9431114c6ca64"
    sha256 cellar: :any, arm64_sequoia:     "6d4157ae2d89e89e2e911a215b672b46d17e28ff38ee443f86c1def353af8e52"
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
