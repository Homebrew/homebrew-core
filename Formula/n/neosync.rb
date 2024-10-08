class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.75.tar.gz"
  sha256 "a328d432a72cbd4e4826986618b8b00f5bce77ae403266e18cd0e54f3f299e09"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80e18d0c1399fe61985f8cb9f26c8a1137d3b3bf39dc537ac908889fc7763a85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a8fe82e707efae799bd144fa8b5e7ce044fc89842df6bbb4ff868fc2f8997f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62814932a056b21207570efb89ec50885ac8c5b6596b07c16b733afb417578ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "04557d512a322f9ec7878f60db56cce0d8acb2b383a75351763885c56d23eb6a"
    sha256 cellar: :any_skip_relocation, ventura:       "02001154b95a719b17f3cda25510a22f33846a57225f4e6f023e366ae59ff05f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abb91f7512e1e3bb1e7e46e5f1af1356cc0542d5f38323fac9b39abf8dc681ad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
