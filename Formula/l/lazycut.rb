class Lazycut < Formula
  desc "Terminal-based video trimming TUI"
  homepage "https://github.com/ozemin/lazycut"
  url "https://github.com/ozemin/lazycut/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "14c18eeef885c90a1660a85d760b0520d1d2256b38e4f5fe5b750f0d34baadd4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "59dbb5eb18b0633b9009c1d4a5512c3d6616dcc1520f96490a7a57ecb2bb4f73"
    sha256 cellar: :any, arm64_sequoia: "25ab20da55223dc1eac22854e0babe69b4fc259473de00121dafc09487cbde5a"
    sha256 cellar: :any, arm64_sonoma:  "20bd9ec19b7bd15aba0b859298df0bdd7358a663f82e87c2f1f4453a191b6d1b"
    sha256 cellar: :any, sonoma:        "3110d099f3136c5dde80c1a8e9c4cb306cb42efa89fb1473638e9d6d065ac8a5"
  end

  depends_on "go" => :build
  depends_on "chafa"
  depends_on "ffmpeg"
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycut --version")

    system "ffmpeg", "-f", "lavfi", "-i", "testsrc2=duration=3:size=320x240:rate=25",
           "-c:v", "libx264", "-t", "3", testpath/"test.mp4"
    output = shell_output("#{bin}/lazycut probe #{testpath}/test.mp4")
    assert_match "Duration:", output
    assert_match "Resolution:", output

    system bin/"lazycut", "trim", "--in", "00:00:00", "--out", "00:00:02",
           "-o", testpath/"trimmed.mp4", testpath/"test.mp4"
    assert_path_exists testpath/"trimmed.mp4"
  end
end
