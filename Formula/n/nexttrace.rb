class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://www.nxtrace.org/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "62adaafbaf263dde37b3e464f6ee8285123a0214be92a056591a02bd6463bdee"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "268e3a1ad283e73d4eecaba611760a785ca36c6c60452216fc9be2156222796d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "da7355775c661aed298da74cdb46383bc19f5aeba6abf2a831ee28bd419989a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "839afd1575a75461f5b53afe67da61baece78c72196299c1c14137efe8db98b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a2bc5d05f67cd031697023f5b30a678ae711ae2d8ebafa09697af61f741bf2dd"
    sha256 cellar: :any,                 x86_64_linux:      "2e4cbc42bc700784a74f8e2e1d917be4b79bd80e286eb7a1dbf6124f6697b21f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
