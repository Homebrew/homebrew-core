class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.13.0",
      revision: "a3f6f4b52f994dfb322f507f05263d52869c4e01"
  license "BSD-2-Clause"
  head "https://github.com/MobileNativeFoundation/bluepill.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "69a5e53d56d1093929bd7f7cdf80718d832834e6c0b1790202508f3b935ee6a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "40123f2981d2e731f0a15473049696f035e8e25f0b27752603550c16e904fd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a92ddfe4cfcaabe31286b25bea4673891111bb9225751574894552d7bc56fc00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48bb18fef3a6ba58029c0167a3bf903b6e7fd88e96af3ccb2dc7cfdcd4846e26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e562b58dd64848a0f333325f2925883f1f3a8f841d9d122b4d7e0a3db032c5ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1c6546ce0eed8ede74042419f0ce6a242dfa971db31806f6927fff369a3537e"
    sha256 cellar: :any_skip_relocation, ventura:        "b89586a8fe4f4049de8446d3e55f040ebf645678b7038a2c59b0c5714db11bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "81990e0749d7b856571867c719d08c2b15ec2414e300ba7dc1a2b0d7dbf6af07"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    pbxprojs = ["bluepill", "bp"].map { |name| "#{name}/#{name}.xcodeproj/project.pbxproj" }
    inreplace pbxprojs, "x86_64", Hardware::CPU.arch.to_s

    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "-IDECustomDerivedDataLocation=#{buildpath}",
               "SYMROOT=../",
               "ARCHS=#{Hardware::CPU.arch}"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
