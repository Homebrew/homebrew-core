class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.3",
      revision: "94d3bdbddeac5539ad6bb04a268126d3f58105a5"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ef2229132469cf85dc9abcdba34f1abc3fc06db346a2b1a424571ad550d5517"
    sha256 cellar: :any, arm64_sequoia: "669af685cd364c0a9689b66f2e825d46f23b468eb267f94c00fcc55ced18bdbe"
    sha256 cellar: :any, arm64_sonoma:  "d7ea143ff7150d84b42c6a02fffebddd6d6045a33ace9228f4fdfd1cb4278471"
    sha256 cellar: :any, sonoma:        "73484e6d937f02cad94a36303ad72570748e5c44a8164904ea2a219e3f0ce89f"
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
    system bin/"media-control", "test"
  end
end
