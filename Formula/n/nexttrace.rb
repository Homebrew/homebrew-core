class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/sjlleo/nexttrace-core"
  url "https://github.com/sjlleo/nexttrace-core/archive/refs/tags/v1.2.1.1.tar.gz"
  sha256 "56fe2986067ed8f84bb30d533309a79f901d9a182f25afb71a8354e5bfad6b5d"
  license "GPL-3.0-only"
  head "https://github.com/sjlleo/nexttrace-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e177d51b26ecb007b220ab6f2de23f8da9eb03dbbf8d1f88824f6460fae2666c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be086f5209dc1eee40ab10d8a0123b0a96ea2239a7951ce62f84320bb7be0679"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f2141fe46e062ca211a015481b3925cd05aec65004ec95f4338008cbf8cffe"
    sha256 cellar: :any_skip_relocation, ventura:        "cddc2a5971066a27cfff7202160af4f1908e6954965a0574b6adaf3f5fcacf16"
    sha256 cellar: :any_skip_relocation, monterey:       "859054ddb09798b9c45a782c8a3337159cf1ec01232b0d5de6d82137c5df21d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "99af9852dfe9e9195f9838bcd2f44bb28a5b91b69f587324f4d56d6d2cc22688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc0536739bceb7a1e6a7a7e0afcead046c6609a2d37f6b2d3b60deb32ae0cb3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/xgadget-lab/nexttrace/config.Version=#{version}
      -X github.com/xgadget-lab/nexttrace/config.CommitID=brew
      -X github.com/xgadget-lab/nexttrace/config.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  def caveats
    <<~EOS
      nexttrace requires root privileges so you will need to run `sudo nexttrace <ip>`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    # requires `sudo` to start
    output = shell_output(bin/"nexttrace --language en 1.1.1.1 2>&1", 1)
    assert_match "traceroute to 1.1.1.1", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
