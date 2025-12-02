class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.6.1.tar.gz"
  sha256 "a18095c677c3751413c47b07daac6b86ff41858ce851bc56661baf7d43aea450"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "e565c44aca59ff18d8e3d96a0c389574e40e2296d33747f50588c3433d6979ff"
    sha256 arm64_sequoia: "29ac0a7cdb2cf55171f4bd8eb20350bc9da525217d6ed99c44f55ea85d4547ad"
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
