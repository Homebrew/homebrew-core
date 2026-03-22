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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae2cfe945c714c811d90f6cba40b5f30421912ccc3b483e3ec84c09446418a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b7941fd708f17796c4d52c4954011ba011c9e832a5d3be61f6823f78fdc7c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbad1d29f86304f9a3b8f775fcc554f751b9a8365260414aa9b98cb2ff15c2a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f311dbdc3b3db59cfcf056090645ef47e12e37e6dce34def668f9a35865ebbf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f954af10843510adf07e55f32aee41200fa65a4ad87b0e4d4d580941a9da2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd95da27bad69a6b6aba1abb57410d0877e3aaa591b074f349b8e98d7449ccb"
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
