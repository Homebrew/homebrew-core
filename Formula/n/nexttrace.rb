class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "b4baacf2dbd30248325da9280c3f360ca1162ddd1e412cb8c78748dc4b9b245b"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4a483ea03202c6dac0be25adc6a5828f53b3ad2894577e34cc97bbac9f98c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2694ec1f4601fd62f59f0eff1bced96384afa0a868251d39a79fb9cb2ba00f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd2806d45a06b08e095268556dfc07a999e040a970e1eb86270f9ad629ebf5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4fc252f2b1d6c17087fa914bf24081e0c4817831cb28d5392f55c5c0480e1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8559e02d3d2c16cb0135dad34d25392d113bcb631040b00b1137aba4bd021d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62cc632dba71f3cc61237f29528083acb1e74ebab2cfade42730b90f35a06d20"
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
