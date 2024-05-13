class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "b6c377047195097e5339dc5981d4c10dbc9a98fb924c85cf66f91d25b20b1179"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1ae8b3f4af344ee0bc82839c68bb447f38e48f8c08b5f508758fc5475d2e9f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dfdda49f697d1fc1297339963f14588e4b860277b350b80298f5f7837f29b1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "312dc5045e0590870292fc575c8ca4dfbc9970415d62103df83e6ebfb379fe4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebdab7395ed60c83ccae821a2868ebbbed5a424d13634b9986089770c0284187"
    sha256 cellar: :any_skip_relocation, ventura:        "318322cf1e4b086bcea6b475b6d707e6a0ef2b2da41949d807cbe8e933511460"
    sha256 cellar: :any_skip_relocation, monterey:       "2514e555d233d235e44bf058ea23e02ddf506c976b11e2489499d33cdf7eab92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f6fb65a08582aa9dbce7c87a639b802de4d19681c6f496ba771e848fb98cae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
