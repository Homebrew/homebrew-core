class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "acbc3a56cf3606314879986cf2a420a3dcb6c797c0611085fe13f514c12e4c91"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c8eff199a60fb4fc9bd389cfdfe29142de509dd96fde45fa5fbd2abc20f9858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c8eff199a60fb4fc9bd389cfdfe29142de509dd96fde45fa5fbd2abc20f9858"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c8eff199a60fb4fc9bd389cfdfe29142de509dd96fde45fa5fbd2abc20f9858"
    sha256 cellar: :any_skip_relocation, sonoma:        "82463700fd53766aaaad3d1fe2d0d2148c15e561e66e52c6138366dff6312a07"
    sha256 cellar: :any_skip_relocation, ventura:       "82463700fd53766aaaad3d1fe2d0d2148c15e561e66e52c6138366dff6312a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69ded2be31dff1a588b4a28ea40e45eb2a87fc64d01b09522168fe62fd2aa577"
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
