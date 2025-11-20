class Gfxutil < Formula
  desc "Device Properties conversion tool"
  homepage "https://github.com/acidanthera/gfxutil"
  url "https://github.com/acidanthera/gfxutil/archive/refs/tags/1.84b.tar.gz"
  version "1.84b"
  sha256 "f1b3779fd917b8fa9b4286f0e451617fa450e740df6e780651341dfebec868d9"
  license :public_domain
  head "https://github.com/acidanthera/gfxutil.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "aaa2bcf67a5e5655cb62fcee4118904fba8f0f195c908c2d18576f3a7680d817"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "63bb7dcf0a63573ae3d930724c50172fdee932cebf3733d5862cd961fa2ff5c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0bcf7f6998efc819378c5b42de7ef889877a8dfee552c50b19b2e936ba90730"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0346234f7ca528ca436186c2b4aa58a398756e6ac6ebaaa3329ba95b915835b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "884219668e6a3456f9060d164c912368804a2a3f07787276933ea231bbc04a27"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5ab4c2ec89a9792213e18bfcd7527ebb520be4cf9d857f5cdddf0c28c26c298"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e9bae4270a0855f7c5ca16fb69afc795c967ac09eea19a4114695275c93334"
    sha256 cellar: :any_skip_relocation, monterey:       "2fbaff1968522b5bbfd4c0e040f20da9c366a98a3e760403067edbad6a4d5ad1"
  end

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
      shell_output("#{bin}/gfxutil -o hex -c 'PciRoot(0x0)/Pci(0x0,0x0)'")
  end
end
