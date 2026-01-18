class MediaControl < Formula
  desc "Control and observe media playback from the command-line"
  homepage "https://github.com/ungive/media-control"
  url "https://github.com/ungive/media-control.git",
      tag:      "v0.7.2",
      revision: "7f2b6107eab208ac6f7dd206232c7a8eb5c34aca"
  license "BSD-3-Clause"
  head "https://github.com/ungive/media-control.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5d30162759b982c646ca3223f2edd5891e28dc73debfe336e0ae8307c81eec05"
    sha256 cellar: :any, arm64_sequoia: "b19b1fb4cabe60ff109d6cda49c4e672cc4dd6cebdda68b058360ca613c22adf"
    sha256 cellar: :any, arm64_sonoma:  "74a0f658133dc87eb38de4622fd6492da586914aa4d7a91db9777b2826d23523"
    sha256 cellar: :any, arm64_ventura: "c66d4d35ce48365ad154df1549ac24a5a51ad01e7410357dae2f4e4afea46c79"
    sha256 cellar: :any, sonoma:        "302a37ed8cd23fd9e78546f31247b25cf87460c49ce8e87d9966be4966e835c9"
    sha256 cellar: :any, ventura:       "0ad7f71a81a3fb6956bec6974aa83413982410b1e74400192499126a78801975"
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
