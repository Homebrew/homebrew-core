class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "e57b1884cede897cafbb2294c133193dc3db51e16771b6b2affab58c24e03507"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "683e59c1daa67cf6f6a893611f33d27ab38f9592774fbe64d61b597293d7cbcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686c94d1a32a4122b9bedff6f8b591fa2cdd763d8565dac6ad0e6e36f95af027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89b662856ade795d73ab2dcabeee55b63afe95378033d1e007ae7843b1f16567"
    sha256 cellar: :any_skip_relocation, sonoma:        "f50d5b15901f66cf84c299b5edd0c52cb0cc04afeb82942d9a9341f8c7d5d170"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a783aefc2b56eb2ddd1f7ed5baef08f1a03b6d175a4e2494e00d5c93e5a4d1e3"
    sha256 cellar: :any,                 x86_64_linux:  "d6371495e0a3eca2c2bf62b463a5ef2c1b2f9f1cdb5a69a545794d5165539ab1"
  end

  depends_on "go" => :build

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
