class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.8.0.tar.gz"
  sha256 "ee6863984c6d2d31ca998d0fd64d95ce4b098b86a77f1b747f9dafc8fe144b85"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "7f6197b7f3cb571099efbd01d0bc346024726235161c36c6669b7e55a942d830"
    sha256 arm64_sequoia: "e31e67acf32149b2b7543fa4b3b7dc0014b3be6a1ab00fd6bf79163953cf88ae"
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
