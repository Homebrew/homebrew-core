class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.12.2",
      revision: "304ddfb49eb73fa9d27104329e98d4fa2b62e856"
  license "BSD-2-Clause"
  head "https://github.com/MobileNativeFoundation/bluepill.git", branch: "master"

  # Typically the preceding `v` is optional in livecheck regexes but we need it
  # to be required here to omit older versions that break version comparison
  # (e.g., 9.0.0). Note: We don't use the `GithubLatest` strategy here because
  # the "latest" version is sometimes incorrect.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b3a111875273ff1fac5ef0f0b198cf3fad3e19358990bbfcd453b0ff864e3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1762224529b39fd7c55f12afbd650c93d6f7875c0543b0d1a1d5f405b78ea322"
    sha256 cellar: :any_skip_relocation, ventura:        "9ccb25145d88fc887279aeecaa0cf68d1b6d99a8e9cbd62e4bd5af00b4794853"
    sha256 cellar: :any_skip_relocation, monterey:       "8c7d92a43ad83512dffa244d97a358b23752ae27bb6caa520a73e528a7618ed2"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    pbxprojs = ["bluepill", "bp"].map { |name| "#{name}/#{name}.xcodeproj/project.pbxproj" }
    inreplace pbxprojs, "x86_64", Hardware::CPU.arch.to_s

    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../",
               "ARCHS=#{Hardware::CPU.arch}"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
