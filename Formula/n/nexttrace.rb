class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "76ccf68f24bee595e5d6f27f76098c3841b425549f740a3f961d2c44cf0baeec"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddf1481c83e3acf8ecde25cacbd589640871736ec42ad7532603e729f8098244"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d5dd1c150837397ecb1c642fd428aa42e6920a8a5710842d24a352bb4aadd89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97a158ce41c111437559edf3cbaf6835af1ba45d0735da2a10b8dff9ae082f55"
    sha256 cellar: :any_skip_relocation, sonoma:        "863cf6be05d7b21703380a1ea568435ef43a7072ad98da39a571768190900068"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d9b5108ba9e1a577700bc474ff66a8172e0f1f1a1967c7d93cb8013ca3ac20e"
    sha256 cellar: :any,                 x86_64_linux:  "fa7ee7d8c3797c46c3b06ce70e908063f8df5088f30135b7f1e6f6f94f52f90f"
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
