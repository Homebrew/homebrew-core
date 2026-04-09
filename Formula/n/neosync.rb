class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.41.tar.gz"
  sha256 "f11966321826d40d28b087b1daa81519e600759b9813b0e686ec49397a466a21"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc8511aed8b89a42f541a67b4dad182c92b035ccdd80b9c72876f4eba0b0ba83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc8511aed8b89a42f541a67b4dad182c92b035ccdd80b9c72876f4eba0b0ba83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc8511aed8b89a42f541a67b4dad182c92b035ccdd80b9c72876f4eba0b0ba83"
    sha256 cellar: :any_skip_relocation, sonoma:        "172953b083fafdc022eb569843bc73ee34a2748a2ac38538aabfcd02b31da70c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "287fca0fc0f4f143b28c9086ec8a9459bf07476d5929e01eb355863e31d2d4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5902ad8c570eb479ae4f4a4f2b87e601e633357138b9f58f22fc46dcfba1a8a7"
  end

  deprecate! date: "2025-10-02", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
