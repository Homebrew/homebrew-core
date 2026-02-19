class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.9.0.tar.gz"
  sha256 "7ffe905fea325b01f6090e95fd97f9165a69080e12b928a55f927b8adaa8949d"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f1064610f320d7c888a99eafe6469d4b1ba3bc928d32028a26106b634c69a264"
    sha256 arm64_sequoia: "14a8b833341d8e79b46ae990b60fb7d61c032e36d38db037b79cc931f52e563b"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/container-compose"
  end

  test do
    output = shell_output("#{bin}/container-compose down 2>&1", 1)
    assert_match "compose.yml not found at #{testpath}", output
  end
end
