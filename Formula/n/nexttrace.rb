class Nexttrace < Formula
  desc "Open source visual route tracking CLI tool"
  homepage "https://nxtrace.github.io/NTrace-core/"
  url "https://github.com/nxtrace/NTrace-core/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "c9dcd1575d4ee8f821a7eb73daac6c2c8a18360337e78f328722a4f3a5f189ea"
  license "GPL-3.0-only"
  head "https://github.com/nxtrace/NTrace-core.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "75be7efd4f04c06d6899e550f71b1d0ac711d2d53794ce05f62500275cdc9cfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "968b3aca3eca6d4e2b87ee06ce67650a31a1d78f712c9ff8aa6a9a18a35c4ced"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35eafe484dbc12c650bfa5e59e3d343b6a260fb58b1be1ed2b267cf249dcb47e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3aec175fa0d6f6d3e18615521b6eff02adc450d1fbeee554c7093876b949c6d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c0fee3e4039e734f84134500b53cae283df0b132341b53e66b0633648eb52dd"
    sha256 cellar: :any_skip_relocation, ventura:        "effd746fc0f50a9463b58875e40e32de4de3ca7d61b1706d98400e9f4d63ef58"
    sha256 cellar: :any_skip_relocation, monterey:       "202c9265ab8f313545630c6085b7bda87746929f09c08dfbd1d7fb18230a3785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177732fe9f004dbf33e0eb4e683ccb84323ec6487359ef6f1dcb09528486ad3e"
  end

  # use "go" again after https://github.com/nxtrace/NTrace-core/issues/247 is fixed and released
  depends_on "go@1.22" => :build

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
