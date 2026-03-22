class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "375e6f367d8eef950eabfee5f9da318468b00c1915b35c1e5006154c2f6cec00"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d439e1b8197aeed05f0de159ffa6da7a2c91258d913f90b2efb51b67d5b4a268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d439e1b8197aeed05f0de159ffa6da7a2c91258d913f90b2efb51b67d5b4a268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d439e1b8197aeed05f0de159ffa6da7a2c91258d913f90b2efb51b67d5b4a268"
    sha256 cellar: :any_skip_relocation, sonoma:        "24ba94710e6028986e7998742b364b50c3cfb99904a87333ba18e9b44e349011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e7688426be8837870d8ea7ae07f26cb4d1486bfa24d7a9f47d7a81bab7f61a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32857d141d03fd94834d567663721f6153914d4ddfaa1092649547c212da469a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
