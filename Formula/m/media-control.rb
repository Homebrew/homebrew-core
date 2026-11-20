class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.8.0",
      revision: "e711d3ffbdc97add23cf0133d073a1ae773348b2"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5b7c33de79c9dc316b8e15124bfa9037bfcc0117c31cdf14eab6c50009bf0812"
    sha256 cellar: :any, arm64_tahoe:       "41f49bdc10831d383179b7347191444deb06cb5fcc1f3e6eea3588867f55e741"
    sha256 cellar: :any, arm64_sequoia:     "29658b117a51f897073b33a74a24d093c14b56d0a9376e34c6653cec7376f36c"
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
