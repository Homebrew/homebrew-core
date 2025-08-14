class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.0",
      revision: "fe5a9ed26679bcc1a1d9e13b059c28256644d26b"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d592f17344cae8ad3245ec89614ec16703aa1cd258a8447a57f955713e3ad721"
    sha256 cellar: :any, arm64_sonoma:  "ad46b85a1e4ad44af2f333a72ca76d306b036ea1c7c8305bcc32f8fc614f7eaf"
    sha256 cellar: :any, arm64_ventura: "cfa97f1d8bb7af6d27375b8d647e73f30fbb29fb5693a9b1e7796484ce2fda8c"
    sha256 cellar: :any, sonoma:        "af58f15ced0dfc79ec1a57153b6b26d2ab6fe940a381ba6737c4739878f051dd"
    sha256 cellar: :any, ventura:       "c9dc49faadf3f33c2b0f94a87f2bc129792c418d1c5082f387284918f363e662"
  end

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"media-control", "get"
  end
end
