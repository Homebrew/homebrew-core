class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/1.1.0.tar.gz"
  sha256 "8158413f98e97e2cf514cdff4c7e4ce11640d5a78bb91246929164e8112c83ba"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "39b51710b3a9abf3d39700b8467226d48e574a10838098f8ecdb2ca8052fb17a"
    sha256 arm64_sequoia: "40986c3e40d5c8be43e045326921f5d29bf1098cdbb25ccab9f4d10ebcffe732"
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
