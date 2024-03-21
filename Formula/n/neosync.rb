class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.62.tar.gz"
  sha256 "dddca5d326d3ea997121193587b85db1e5f8e4909efdf2a8dc1cf8b9dd6ab821"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5b240e5a2b969d8ef8a87944bf30bd497d2efab6ab839014f5482cb88bcd161"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7296c1b4ba432a0c0f331bd1de496b32413d203821569b2f4144336cffcaa79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a68d565f9888a1cc2b3940e17415bc3cc4141d687889097ce37334b59ed44907"
    sha256 cellar: :any_skip_relocation, sonoma:         "55b135dec4e19a0834f6ce158d7b181cf81612f8bfa90b9a1ccf2f8138f9fc15"
    sha256 cellar: :any_skip_relocation, ventura:        "cd190268d5dca181d27a068efbbb0cd471b5f529570f239860b013f2c6673e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "5ef929e759c402ac145b1dc82bcdc017f02a31b369d8bd99f7874de6abda8f79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43d312bb0a7094d1aee8f1919452dc86554f67810830fa930e427b7fe7527490"
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
