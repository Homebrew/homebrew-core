class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.59.tar.gz"
  sha256 "991b0becb73736285db34f0bc99531c187522a44a525070edffca92d0d31ac17"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da19164e63ff667a424598ba101a0874b556b54fb334819a8db8c72e7412b355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ef90296da6b67e836590f9da1f840be194e170683aa514ade4dfe93074babd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ad306c0f41bba1cbf21163cef44a9e92f0cc729c1de0d755e74ee4e45f3f081"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1d1b61319d3f05d3d9688c56fffea16df87223a98c74da1bb44869916b1c396"
    sha256 cellar: :any_skip_relocation, ventura:        "9e3951d3d6d3fd35a4516fdc8b0561f794bdc8a35245803539c917f46e4ff37f"
    sha256 cellar: :any_skip_relocation, monterey:       "eb956efd240313324f45cfb8e0ca57975c2a0cbabda79f6315292fe7567f0088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4841e2b84da45d3afe3b0cc2784c0d0173576cd275fa67c8946cc03ba29d5d57"
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
