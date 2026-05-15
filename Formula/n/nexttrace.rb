class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "89d19dad8b85821818fcf0a1cc006841f1686859da1b1f5bac68957f3c81ce70"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23279a39d633d61791f5063616d94fb55cb67ddc6ba5719a92845ac55fc5dbe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "751dbffcf3f09058528e1b2b2ee41281cb1227198e79bcbda4de93e4c50c2fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "466748c82bb7eec7ebf21500ae79295b54ad28cf5c52e18f087b8791173ff310"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6e2d29f3ef657905f05bf4910b91daa1e44fb0e0d231abf2aa0a73dccf89486"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57e82a1785d06d304e9c42a67c1f0a6085d866f12c191f729dd9ed585c55981c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec8c415d83ad02f6a996739bae426f019a04d55d7eb5afc9ffb1930c12dd762f"
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
