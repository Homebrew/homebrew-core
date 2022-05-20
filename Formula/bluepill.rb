class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/MobileNativeFoundation/bluepill"
  url "https://github.com/MobileNativeFoundation/bluepill.git",
      tag:      "v5.8.1",
      revision: "2dfc0a965ab564d015a2a0f00be89edf53c0f256"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fdf4a0439be240af92600dfd6b22accd2e66a2615fd3039e44622d545701616"
    sha256 cellar: :any_skip_relocation, big_sur:       "27d44ba07c149043b52f823607f63a10f16b7d94066c93ac57f1aed756e25d74"
    sha256 cellar: :any_skip_relocation, catalina:      "e3fb55552964c2544ffafd63050d0c82463dc98ee4742d761d843272a69fc0a9"
    sha256 cellar: :any_skip_relocation, mojave:        "9926fb42710ce7c6067603a51520b66941b3b86e4827e7e7b63ae73db460ee05"
  end

  depends_on xcode: ["11.2", :build]
  depends_on :macos

  def install
    xcodebuild "-workspace", "Bluepill.xcworkspace",
               "-scheme", "bluepill",
               "-configuration", "Release",
               "SYMROOT=../"
    bin.install "Release/bluepill", "Release/bp"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/bluepill -h")
    assert_match "Usage:", shell_output("#{bin}/bp -h")
  end
end
