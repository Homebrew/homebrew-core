class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "6def8e05d0311aa864e6faf99884ae408fa4c2705232671c334224fa0e34cd3b"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57701d87189b5761e3017c781ace66d53323de23d2f5ae290ca57fcbd7cb95d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d00e3a1fa96c0b14ca15f612ac887b5946b4365b6dbc3563c04bfec0c5e51ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f050b89b51e7f62ab1a24ce1006c4a64b79d9c67dc300b72aac95783c0fa6956"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a83110f2c871b488da1c179dee214224a06c432a623d92984152df3188dd33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d04c1d29b8554cfd13096a728202c22d1331dbcda8de0612e88067b4fcdffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a85180f795fbc50ce16d76d366c608daa73e75b5cd9acfd071497a50e4aaac3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nxtrace/NTrace-core/config.Version=#{version}
      -X github.com/nxtrace/NTrace-core/config.CommitID=#{tap.user}
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

    assert_match version.to_s, shell_output("#{bin}/nexttrace --version")
  end
end
