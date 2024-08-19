class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "30a22f9d94fafcb64a26bad490803a1434f5d695a4fc7d7dcbec73be7f0329f3"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a4ec666811db32583458e57ad1e23b0a750a77259a527707d7c8fc4725c3ff5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1dcf2460793c3f74470d755e29e1f870f1b78cc64ee9825cfcc542ac906a882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20ac6c59bd66dff27ddc8070b4c0e4d5a3235e9cd5426f8b93b95bb97c32a981"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d6af572a724e857db8c506722c9c48fb202fe6c8ef323487ae6d75fffbac396"
    sha256 cellar: :any_skip_relocation, ventura:        "93bcac1a533c78e8f32b65cc007f4edf5a6f2f04f9ae53589565582b15760f32"
    sha256 cellar: :any_skip_relocation, monterey:       "477a2f3218765a281542499d21c50ef57e2db350f8b6b1d0d462168633fda045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90f31d9c8689e87102573b8e21b0551a55a19a8bb0b5ec8187dcd4fee7d086c"
  end

  depends_on "go" => :build

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
