class Gfxutil < Formula
  desc "Device Properties conversion tool"
  homepage "https://github.com/acidanthera/gfxutil"
  url "https://github.com/acidanthera/gfxutil/archive/refs/tags/1.84b.tar.gz"
  version "1.84b"
  sha256 "f1b3779fd917b8fa9b4286f0e451617fa450e740df6e780651341dfebec868d9"
  license :public_domain
  head "https://github.com/acidanthera/gfxutil.git", branch: "master"

  depends_on xcode: :build
  depends_on :macos

  resource "edk2" do
    # Pulls the AUDK from acidanthera's repo. The checkout is necessary
    # compared to pulling a tarball as GitHub's link to download a branch will
    # always pull the latest commit, and this allows us to pin a specific
    # commit. The revision is the current (2024-08-09T11:25:00-05:00) latest
    # commit in the stable branch.
    url "https://github.com/acidanthera/audk.git",
      branch:   "audk-stable-202311",
      revision: "cf294d66704d797e2ebb73cc7d04c5b322c543da"
  end

  def install
    (buildpath.parent/"edk2").install resource("edk2")
    xcodebuild "-project", "gfxutil.xcodeproj",
               "-arch", Hardware::CPU.arch,
               "-configuration", "Release",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/gfxutil"
  end

  test do
    # Previously, I was testing functionality of the device finding
    # functionality of gfxutil, but that was causing issues with GitHub's CI
    # images, so we'll just test for this since it's cross-platform and doesn't
    # depend on specific hardware.
    assert_equal "02010c00d041030a000000000101060000007fff0400",
      shell_output(bin/"gfxutil -o hex -c 'PciRoot(0x0)/Pci(0x0,0x0)'")
  end
end
