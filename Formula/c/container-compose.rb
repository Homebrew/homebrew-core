class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.10.0.tar.gz"
  sha256 "dbdabf599237cadc4840630a84591ed2c339feea9f9efdbba7e3422e6f58289b"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "e08f19c9f4c10d96e75ef22e2c5be80a7b0e90476c6bc4259e026c91c639c3e1"
    sha256 arm64_sequoia: "440f37fd1ca5766b67d96c5e1d0204c55f46c67e1b986011f14889028709aacd"
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
