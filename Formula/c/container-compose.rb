class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.7.0.tar.gz"
  sha256 "8e1db3797b135799f7df6ebad11934a474ec0344ae69866c46957a888d13a88d"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "de1b6982623810147fd918bb53bb5ee53d8cdd7559a2b7269dc255e0ba0235d5"
    sha256 arm64_sequoia: "dc97b870c757db9a5bc35d900d8ce7411c467e9f37ee3f2eec339f55b51d42f5"
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
