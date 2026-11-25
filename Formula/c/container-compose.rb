class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/1.3.0.tar.gz"
  sha256 "2a7788474b061d5e40473723fb052a4282e8d4cf9548344369517abef1880a6d"
  license "Apache-2.0"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  bottle do
    manifest_sha256 "c1e7679f8a9b881b4edc4e85915aada141964481a0763a1318d9510169098547"
    sha256 arm64_golden_gate: "d46dce56cf57bedd04046ee7be34006417a1dab098eee24796812ca060577901"
    sha256 arm64_tahoe:       "fa37e6e0806c7699a7f43968a425f5f6f64be4efa6e917734470344685afc50e"
    sha256 arm64_sequoia:     "67d6207f5a48b361a557007e578983aee790f1bd1279337b334301b74407aa37"
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
