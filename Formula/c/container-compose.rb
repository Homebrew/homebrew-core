class ContainerCompose < Formula
  desc "Manage Apple Container with Docker Compose files"
  homepage "https://github.com/mcrich23/container-compose"
  url "https://github.com/Mcrich23/container-compose/archive/refs/tags/1.2.0.tar.gz"
  sha256 "f7bf17856e9eecf3ed711cd32b93297c20c2afc7b47efd2f316aae52ccb55830"
  license "MIT"
  head "https://github.com/mcrich23/container-compose.git", branch: "main"

  # TODO: remove if undeprecated
  livecheck do
    url :stable
  end

  bottle do
    sha256 arm64_golden_gate: "b4bb037d0d35999b0e737b03791212e8bd06f62594b56350e056588ca36cb214"
    sha256 arm64_tahoe:       "de2546ced76db4244352f6962673ebf29725a19b62c175964406ce58c4c5a4b2"
    sha256 arm64_sequoia:     "91f9fa8cf9f3025776412acbda1f5f877128d75ddcab819d1c48943807e2f151"
  end

  # TODO: Can be undeprecated on official new release or if upstream confirms change
  # in upstream issue: https://github.com/Mcrich23/Container-Compose/issues/158
  # See: https://docs.brew.sh/Homebrew-homebrew-core-Maintainer-Guide#retagged-formulae
  deprecate! date: "2026-09-18", because: :checksum_mismatch
  disable! date: "2027-09-18", because: :checksum_mismatch

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
