class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.7",
      revision: "3cfd5dcf78e7a619f7a42a3e2f29b06eb41027ea"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cfc4cf0de19ff242e778ad128ae8426dd9cfceb1219dd6805fd4e00705b9b887"
    sha256 cellar: :any, arm64_sequoia: "841f859af49fc3eb06f281a32542e981a9f89a8ef78eda6085aafdf6c567b15a"
    sha256 cellar: :any, arm64_sonoma:  "3260ffd1db588139a363dc1930d5e13d23c56864707be2611d6ffe402a5a366b"
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
