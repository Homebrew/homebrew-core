class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.60.tar.gz"
  sha256 "b3dbee512b9e8b73fe7f5880364611075e426d681672f64d75b2987b9da3ccc8"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c462c911f10c098db8a848f6538a0f2ec2e5af77a7cab1ef9463d8f20d3870fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a5db3fcbe1fb80c267f5e2fc83e0e37fa3b668b2cd1bd7908d7ecf11654feb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21ace1b37f1992ba4452b86e05dbe47ae6025c874b410f12088c681502b7cd07"
    sha256 cellar: :any_skip_relocation, sonoma:         "97287a4857291ec6e6ec93a97369bd1cefffd34e5217ada3a5f4c08df7de3be7"
    sha256 cellar: :any_skip_relocation, ventura:        "634789754a6781e1990d5e055136c66dede6b0aad7b5ca60e756438c901b93dc"
    sha256 cellar: :any_skip_relocation, monterey:       "3bee64f6b60b6610f068b8e2e4d51f8c5b6daefb52032f48f2bd994912e87461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e5efa79ad1dfcbcba26dc72cb4559d70669d05f6e891c75c9be9e7742f49b86"
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
