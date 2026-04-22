class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "1d65e38e7d555bc165dd2b2235fa076418f2adb5c4766a91f1f44ec083298f85"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22bf5df17fbb3bea2f44af68cf3b4a1e801f6ac73a86b1aca0c909f46acd2cb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a2d0ae6fe7d68e731884fe8c18ff6ce1f73c3e03414454b4d8d44c1c6c6bac0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f70081b65f210d0f525d39c30f6d79a622c81228f6542ffe77dfdd7c2ec32e04"
    sha256 cellar: :any_skip_relocation, sonoma:        "6137225484cf383060ff67c0fe21204459ba8781a293b9d6da214c785688d10a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10b55cc9246f92705367ce3423a0f0715aeb28b3f271b6a2125f6bc110e4b13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75e22122031c6365c3b53341b78b9f8f24c9987480b78802fa7bb500ac379b2a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=#{tap.user}
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` for linux
    return_status = OS.mac? ? 0 : 1
    output = shell_output("#{bin}/nexttrace --language en 1.1.1.1 2>&1", return_status)
    assert_match "[NextTrace API]", output

    assert_match version.to_s, shell_output("#{bin}/nexttrace --version")
  end
end
