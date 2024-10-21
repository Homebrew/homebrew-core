class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.79.tar.gz"
  sha256 "2df7ff94eb12ae36fe3947468ea2e263238f3bd18411b6cbdb754613c311e266"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2577c19bfd6608e98c395eab8727998b8af01c4f49845138d5dbc3ee184182"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2577c19bfd6608e98c395eab8727998b8af01c4f49845138d5dbc3ee184182"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa2577c19bfd6608e98c395eab8727998b8af01c4f49845138d5dbc3ee184182"
    sha256 cellar: :any_skip_relocation, sonoma:        "8350b28a19626072e93b3fcd898545c60bcd57457f7ca7047f9ed387cf5774e5"
    sha256 cellar: :any_skip_relocation, ventura:       "8350b28a19626072e93b3fcd898545c60bcd57457f7ca7047f9ed387cf5774e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5a8719488f776e6277dfaeaa15a75cba219118c237c8ed3764f580c9044ea03"
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
