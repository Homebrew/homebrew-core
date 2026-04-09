class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "f4cefb90a5e1f475366940e91f481f180577ff2fb0ef29edd5d7457a7add64f2"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d611c0d3a668465df8abfcae0e74d08751e12a1130ff34efcdb2edbd2d198f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20cac5912ffe63118b12d12efc8dff29f3d3deb55100ff60c2e7ea7439839e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfdb0297f32919fbd5b48f20e8f544e01923160ba5fd54aa3d061fa3b11ce73f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3d2f2b33acddd71e79f6f43761434d079a037cf420482402477d850117615ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e95f94da2c088338f2ab4ebecdc91ac3c03f466f180f9cabb7a81b6e781df393"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee804de76758d6b753f0882015f3e6f4424fa991ed5be44e6a65871198da0f0"
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
