class Gfxutil < Formula
  desc "Device Properties conversion tool"
  homepage "https://github.com/acidanthera/gfxutil"
  url "https://github.com/acidanthera/gfxutil/archive/refs/tags/1.84b.tar.gz"
  version "1.84b"
  sha256 "f1b3779fd917b8fa9b4286f0e451617fa450e740df6e780651341dfebec868d9"
  license :public_domain
  head "https://github.com/acidanthera/gfxutil.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc3d312f7b33ba6e153ebfc22111d8f5e8037a80ff0d78613debf8a46fe10335"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ee145a2ebb496024e4028f02130c629f532c35f630090b9f4d94dbd3f2fa1ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4e8ea9ec58fff7c3186cad6cc50f50a8af31be3d5f9694191fb9e92671ba6d3b"
  end

  depends_on xcode: :build
  depends_on :macos

  resource "edk2" do
    # The revision is the current (2024-08-09T11:25:00-05:00) latest
    # commit in the audk-stable-202311 branch.
    url "https://github.com/acidanthera/audk/archive/cf294d66704d797e2ebb73cc7d04c5b322c543da.tar.gz"
    sha256 "643d475eb5879428c8beb6e18092d1e4ebc609a859f8dcd34b12f43c0ceb9f4a"
  end

  def install
    (buildpath.parent/"edk2").install resource("edk2")
    # TODO: Remove when Apple clang fixes llvm/llvm-project#190340 (`wcslen` idiom ignores `-fshort-wchar`)
    xcodebuild "-project", "gfxutil.xcodeproj",
               "-arch", Hardware::CPU.arch,
               "-configuration", "Release",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
               "OTHER_CFLAGS=$(inherited) -fno-builtin-wcslen"
    bin.install "build/Release/gfxutil"
  end

  test do
    # Previously, I was testing functionality of the device finding
    # functionality of gfxutil, but that was causing issues with GitHub's CI
    # images, so we'll just test for this since it's cross-platform and doesn't
    # depend on specific hardware.
    assert_equal "02010c00d041030a000000000101060000007fff0400",
      shell_output("#{bin}/gfxutil -o hex -c 'PciRoot(0x0)/Pci(0x0,0x0)'")
  end
end
