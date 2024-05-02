class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "f6e635d9868d3ec8fc850805247a9bd25a05b78bc6b853a10add2806b1e83460"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "924f456ee6a0ad5d1f48ac9a3eb02ca0fc3cdbf971c05ddfb91d80f72aa691f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04061dc4f987b7e71997c28ae494f886fea51ae2dea006b507539b132d18bcfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c30ad9e51f724215d3d8b358d8a04db15819a2b93c860803ac291ebb1d03cce"
    sha256 cellar: :any_skip_relocation, sonoma:         "06615ae53f0293126fa7402e38122524b5c0f9a9b910bb3a2bd0c6cbd832b099"
    sha256 cellar: :any_skip_relocation, ventura:        "dddfb014f561cd97655cd839ee49d872c522f7c2590f59c6256e07e80ce8744b"
    sha256 cellar: :any_skip_relocation, monterey:       "b72db59bd17c49730a8305d37683f1b0e9861fd4fc4040b50fcc8416e1225603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d9e2c3b807ead0d5d2a198b420e72ba005802314264c248769c96f47ec2aad"
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
