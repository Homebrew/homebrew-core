class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "4956737ace65a2ae7623e291287c258493016f481fae96699c693f3c3fdd5e27"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ca22935d5d82f0b2262c8d727ee9bfef022856a9c8ce3f9f18196020dc03c08f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a22b0cf4aa2c3f89aec13b5e7145776dc22c2f7a71c6cd9840b05663575c5325"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d48a09de0c9c088902593e63e81e62df8814e219122ed452e69fc89c7ddb0473"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "637fac418be9e8773d138808d473b1eba51529acde6549cff34a73854f95d056"
    sha256 cellar: :any,                 x86_64_linux:      "30826d80e7762e6062b2d6b19d58b1173ee54d1ea2068ef1d7a57f55a7bc25b4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
