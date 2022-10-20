class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.12.1",
      revision: "dd6d563d8b822113190896dea400d1a837671a6a"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7373831fe04c0d176b524b5b6b6691f85978938361a943ad61f6d8afd4220cbd"
    sha256 cellar: :any_skip_relocation, monterey:       "ef1e09d0fe5e2d21734c10e3fee0c9e2756c8ecf53d420e109aa7c672b215cf5"
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
