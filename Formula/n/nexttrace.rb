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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e5d9d9138c543e1484cf5ec1e2b13b37d4666d1a2c74e9d6779cce7deb01690"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82d2508ef7ec931422b18ee6ae63b12517e6b9c2ae002c5166a158cd55b77165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23b4f5c87c366f9447955b902afb9d3654f971c2da5c6836a3ea12d551a48a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16cdae7298d3c8f1dfdbf5761490b0b728307bb28a900601cad1c4bd18abbf21"
    sha256 cellar: :any,                 x86_64_linux:      "01aef744ce84fd3d473fa53e9532705782f9d00344ac37783f0a3c92a7467d2b"
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
