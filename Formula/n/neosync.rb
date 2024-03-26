class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.66.tar.gz"
  sha256 "16ea6194e4d5d4b2b913bbd97c8db3a5eec0bfd35b486e01fea9a9c6ce18d37d"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f38df20e1edffb0c2435ec721411f5e3f2e3ce1a2b4bdf077083ab24750c5f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0c40b206af4e025cd2cd30c4ac0937f7b0109719eea7dbd592f0baa626c133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c69abec08a75894212f137da48fd26a47a89f72fd39044cc0672a80fedc65c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f1d215309a96e5d136ef2c66068a12341b1fe23ffca7493b18b3357360d76e6"
    sha256 cellar: :any_skip_relocation, ventura:        "fd14a69be1c09f429762fc6144a7368265bfac17edc9da3f2a87e8499f9e1e92"
    sha256 cellar: :any_skip_relocation, monterey:       "79b7baf9e3ac4740a0f701aa717b3354091c95ccc1aba8985009a8df8eaa60b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5ad8535632cc031db97dee38707bff9579e998cb7de20ad12e6fca01b188066"
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
