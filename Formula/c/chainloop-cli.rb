class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "95ae3664edd0d59025c4f2785ce3b8834b9e2947c1b93d8d9f7e7c5da030941d"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e26f04c19052ec115072e035412026146afc74727c7f0ce856369ee5d93007"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b820cf6cc16d1d27b0eec8d4e7623831886ebdfdd877b6117330c11a9a3eecb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "445b6ce4b91664feab418a1ddc6e0ea408fd1cbeb128df5b1bd6849282199c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "81594a6aa5bf7e210689b900483d70df88d6fff541401df52b800c039895c7dc"
    sha256 cellar: :any_skip_relocation, ventura:        "4546107d59e491997841c232815ee43eea7154bef8e26e4e6ad33f10a84d04a2"
    sha256 cellar: :any_skip_relocation, monterey:       "423a779caa9b4daacc0ac4da55d167b07ae6eeeaaac258b3146e2d91535c1a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35deaf2fd897c500c868124a7db4499da67dbafc82ed543d92ea53a8f312d874"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags:), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
