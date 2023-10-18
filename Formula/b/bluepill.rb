class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.12.5",
      revision: "a8e6c3391290394a4a4bfeb7e3dd232faa8e2d00"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0ffa6af5fa7bfd51c38de8b99070da76841dcf257e851817a8b114572495069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d2facc7ec129d0fa81f8f3d41d5142cc5a46c013d96e95c191eeea9aced9075"
    sha256 cellar: :any_skip_relocation, ventura:        "41d58786aa26333752352a423248c6ab7caa037e0d410a98696aa1dbde5558a6"
    sha256 cellar: :any_skip_relocation, monterey:       "4556f2d4ed6c5ca9f4054ae3e06c77aaa8e2c91306a62d58fc969fa50304d05f"
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
