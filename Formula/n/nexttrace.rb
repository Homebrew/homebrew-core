class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://github.com/nxtrace/NTrace-core"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.2.2.3.tar.gz"
  sha256 "df0e629b6fab85647a5089a76594a88f887f8c7cf37c89a6a2e646f5dfa6248e"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "691919a1042d9e26cd745b356288ccfbd6f56a9cd7071beeb7578a240b16b5ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b460bb5a31ee865868500cda30821deaa318077038c6c3d6fea70b9714d058d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e10ba66092725cac9220f73fab163a1b71b5be68cbb50ef4b42e7bdfc036b1e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2adf4850e3452df4a2eb273c129fb68e4ad5879c36ef67ac10eaa0cd679459d4"
    sha256 cellar: :any_skip_relocation, ventura:        "dceed6f9ece74be2b15f28c2e1aca66715858c9911ac5a162eb37b6873d4b2aa"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd50a78e8e5eea3cadaf332dae88b42d072a696c072078e677dcb5fab8c78ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85683e40eac0fa5f52e6b81e74bc64cf25957f93cf9c1031e83bd9e6ea07475"
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
