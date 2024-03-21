class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.63.tar.gz"
  sha256 "488002f30ecda79432af2f58c1bd8de57343c8cceb603f8d1856b7d3e8cb2ead"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74f3d3162fc93be30b73a9721fd33b8521c1a177b978b27ba14cc5ed977f57a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e268bfdcf33d9b55c13d81b81b79a2df2081715e16b7ebcfcde8c1b744e34d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4841ec7c1b4784f1c5968918acde578f52e786b39f87bbbf6cced3f2c97e1f7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "3310248731c4a9b775d370acfed546d8c9d3a6e560542d0c4f46d5671fbab39e"
    sha256 cellar: :any_skip_relocation, ventura:        "41b4329d632ff50a5fc970280569bfc65d3989c7bf30bdbcac05b4946c14ad4d"
    sha256 cellar: :any_skip_relocation, monterey:       "4a7274bb94c381b71fadef66d83685e40e1f5aad4616d2ab1d606ab8f86ea0d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd53cdd9e70dbcefa48cf1279a7d9c3507d7164d9f67cb777eb34bac9138c6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
