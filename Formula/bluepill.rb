class Bluepill < Formula
  desc "Testing tool for iOS that runs UI tests using multiple simulators"
  homepage "https://github.com/linkedin/bluepill"
  url "https://github.com/linkedin/bluepill.git",
      tag:      "v5.6.0",
      revision: "ca19302bfbc48e1cf0ccf28eaad431abc6f78582"
  license "BSD-2-Clause"
  head "https://github.com/linkedin/bluepill.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "74d6f5f15513a23c60a9a6fb0c1e8d6e01b74d73466821b66891a0402e10c4f7" => :big_sur
    sha256 "2f6fb626e74027dfa8cdc9a03f66e97d6034e4e32edfe327e544f0cd0abb8ed8" => :arm64_big_sur
    sha256 "c05dba48f83e600ea0104f1edc4dd5b88017fe9ee487544bd4f78b61e2f4154b" => :catalina
    sha256 "4459ee11cb00af2e0ae2aab7052a442cfde2a4b63d78abfc333df8b8b6e6badc" => :mojave
  end

  depends_on xcode: ["11.2", :build]

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
