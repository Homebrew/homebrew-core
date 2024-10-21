class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "8a373935e92bf94959898ce4a6980269270ce5ca88cbe5fb04dd1b3bfeb620fd"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ee30f11117168da4010b9c58bd97aa72a1bb1639315f6add861fe7b34d007d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5bee2bef7ceb80340287776cd8c9613232d59f274a27332a7b0858f0dc10d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "655f5897e273bb725cc69063cc7a86333e76b4acd8b1f21a16165d79e2d56188"
    sha256 cellar: :any_skip_relocation, sonoma:        "e196e386e5950104b094dc1c5704315c614bff0ac5b7168613281a502a69d0f1"
    sha256 cellar: :any_skip_relocation, ventura:       "2a95597e78b4bc1093a9507fe988e463a18c1357d5f5ea31a523a9d3c86759bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55d83647143535207d8207bf7e90b2f0bf50efcd5ac4edd93b1e36d64cfb6298"
  end

  # use "go" again after https://github.com/nxtrace/NTrace-core/issues/247 is fixed and released
  depends_on "go@1.22" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
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
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
