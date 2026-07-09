class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "ac5c3f4181b061b8fff2430e2b34eee165e7a8f41eb694a07ab0b4b219e5a4bb"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a6624e5fdec19c2261446ec63a4e3969006402194cf1a06a00bea5b24904e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f2aaa70b7556d269f0461112b8eeefab13a1810844180403c25c31420d9652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd18ce024f8f018b5e00f259365ec74ef5f7f9902b849a620d8ca22f0ce494d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c0be4907b9b12bd4e2c4280dcdc1138d531c06dc75e2a805953d248a17582e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b524cb4906267c3e52755f4d5754df078183f64f393e3ed8a774550f258261e2"
    sha256 cellar: :any,                 x86_64_linux:  "4273374f96169a2464942484cabecb8c7317c964873f75518a0babe8cb98c774"
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
