class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.5",
      revision: "0a59ae801af0dfc20ac777599015484667857f60"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6ae198faede00e51f969c3680859043c3121d5f5a9459e1b6ec1ff21905c9f66"
    sha256 cellar: :any, arm64_sequoia: "ab32951b2c1c42ed8bb6c27ecb4af03e30c145aae6953450181d524e5765e54a"
    sha256 cellar: :any, arm64_sonoma:  "bf21bb7483186d8ebe535d41567b9906fd5305a6fdbd8a73bbb992178bd63b9f"
    sha256 cellar: :any, sonoma:        "d93619836aa5f2966dfb0b562e17b1082338e4c4c2ec5460b663bbf05e016da8"
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
