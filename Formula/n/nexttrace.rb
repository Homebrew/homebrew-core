class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.2.2.tar.gz"
  sha256 "4edf6322329d3152e0e2318edd0ec4fe068902d8a6b4968dc955da19ca012bc0"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2204876f34b53abe7642877eccda227986978cd91166b8c4d12b9e09238ceee3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fcad9de90ee145076c473f27066fef7552ceb3664eb9dd8b2f6b9758dc31d46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "122bef8c019224e46c9f105c6919ff56b47244b0290c2308b2d08c31dc37a705"
    sha256 cellar: :any_skip_relocation, sonoma:         "856b2554a8a4b952bd198fe059029bd276f471d60dde3bd6c0f2b6bb30266fe2"
    sha256 cellar: :any_skip_relocation, ventura:        "66bdde06e9f5d9eeea2eb71c235738f812bc77429ad3faba66ee6c6f862a3f82"
    sha256 cellar: :any_skip_relocation, monterey:       "8287e5ddaff2e768c67641881b06371ec6652697d0ccdb1cf1280665d016b4aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbaacbfd5fdd5d7c740de241ee676df9d4c47414240019d70eff534115295ad7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
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
    assert_match "[NextTrace API] prefered API IP", output
    assert_match version.to_s, shell_output(bin/"nexttrace --version")
  end
end
