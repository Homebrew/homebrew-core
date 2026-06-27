class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/1.0.0.tar.gz"
  sha256 "3b31038f6ced86ce207d384112378b0d57d1882bd6d34cae5684cd06a9169d83"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "5fe48a1d2fddefb6971ef147977768f42c3b4fbf6b816d30f2cf39abe74f3b02"
    sha256 arm64_sequoia: "1474f32463ad7dceec41a225717d513a078b4ec26511586557700b2fab3c03bc"
  end

  depends_on xcode: ["26.0", :build]
  depends_on arch: :arm64
  depends_on macos: :sequoia

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/container-compose"
  end

  test do
    output = shell_output("#{bin}/container-compose down 2>&1", 1)
    assert_match "compose.yml not found at #{testpath}", output
  end
end
