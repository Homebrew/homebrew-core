class Crc < Formula
  desc "OpenShift 4 cluster on your local machine"
  homepage "https://code-ready.github.io/crc/"
  url "https://github.com/code-ready/crc.git",
      :tag      => "1.3.0",
      :revision => "648b3520011f493a1f420196dffb4709d60a7479"
  head "https://github.com/code-ready/crc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b6d162b76f303e9a84556deea99d9e3c350bdfb7255f822f20a73caa6efd3ac" => :catalina
    sha256 "2e097f5bdcc225c0164939458eceeef0a84c680741164a1f5c8fc5e6a40e1d9a" => :mojave
    sha256 "d8e8cacdaf9a12267efbb962a460e0a9712ae791f9c1fcb335bbd1650e59223a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "out/macos-amd64/crc"
    bin.install "out/macos-amd64/crc"
  end

  test do
    assert_match /^crc version: #{version}/, shell_output("#{bin}/crc version")

    # Should error out as running crc requires root
    status_output = shell_output("#{bin}/crc setup 2>&1", 1)
    assert_match "Unable to set ownership", status_output
  end
end
