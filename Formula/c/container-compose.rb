class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/0.11.0.tar.gz"
  sha256 "1e7dd2bbefcad0e29bf6f6651898c3b1090e192663a23a8311ea7e9ae5833379"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "279c7d7a8cb980fea7b25d42880b75df29434521f0f84cca21538f158e5895ab"
    sha256 arm64_sequoia: "40c4cb92c60f3360284b74cf2202d329431fa099d86632c4eeae211a95d4ada6"
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
