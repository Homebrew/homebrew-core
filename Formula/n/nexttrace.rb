class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "94f8893f80b6b0a8d02b2fe709a62557034f3e32879a55807c38cb6ee2f8ab01"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b5bb14877fa350d7773932829e4335623b50ade2686c3f44d8cf079fd09196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8b5bb14877fa350d7773932829e4335623b50ade2686c3f44d8cf079fd09196"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a8b5bb14877fa350d7773932829e4335623b50ade2686c3f44d8cf079fd09196"
    sha256 cellar: :any_skip_relocation, sonoma:        "93a381eb86c70db50cc45be13c35e5572394aec6272f9ce3e307b5adf5971748"
    sha256 cellar: :any_skip_relocation, ventura:       "93a381eb86c70db50cc45be13c35e5572394aec6272f9ce3e307b5adf5971748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ca06181781f7224df88e79f8cad3eea96ed4741f5046d527f4d02cfe7d67061"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=brew
      -X github.com/nxtrace/NTrace-core/config.BuildDate=#{time.iso8601}
      -checklinkname=0
    ]
    # checklinkname=0 is a workaround for Go >= 1.23, see https://github.com/nxtrace/NTrace-core/issues/247
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
