class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "8749883d52be4630c0b557656a487432050cc6e5d125f60d5b1efe646797d152"
  license "MIT"
  head "https://github.com/toy/blueutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3e16d16825d3530b20a6609a20ba191c9c8abc65e52b7559addddbf76c63885"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b43fdbbf7e85765fc4413660e2293a44272415a3a0a1db182b659ce0a59e63de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "099043f1271741184a9cc4c17c77efcb87fdb936285ada725e6383205ff7edf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "34023bd362aeb9a5e4c6b1f0cbfec913bbef22d429e70220f7666c1b31db0303"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "-arch", Hardware::CPU.arch,
               "SDKROOT=",
               "SYMROOT=build",
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    bin.install "build/Release/blueutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/blueutil --version")
    # We cannot test any useful command since Sonoma as OS privacy restrictions
    # will wait until Bluetooth permission is either accepted or rejected.
    system bin/"blueutil", "--discoverable", "0" if MacOS.version < :sonoma
  end
end
