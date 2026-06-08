class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.6",
      revision: "815bcb5fb514da137e75ca5b866ffb2fb72f224e"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "61b1b49fe47ac7722c22e8bfc966c77b95780a75dbf4d6893f90136dccb197b6"
    sha256 cellar: :any, arm64_sequoia: "1850ef31f2f767637b8efbda28c4f0fc1274cdc5f65e2673a70134349a444524"
    sha256 cellar: :any, arm64_sonoma:  "179a21d0233706e75adcb70048386b3e471ad364e192e8ba0da80121a09d4ce4"
    sha256 cellar: :any, sonoma:        "52a07ebec136e88574c620dfaa6cf2121d37aade09967bf4d6bab0d316ee6aac"
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
