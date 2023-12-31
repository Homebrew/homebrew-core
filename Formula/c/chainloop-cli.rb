class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "01c184af5f679a140d3314d5d611e0bbd138ff0b863baeeeabb3e870e8cabbba"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44ab887718a6fe0df4717d98d0282c4975624a514d5ed189f2d65de2be945560"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c5bebcf5232164b35f993304a933c24135b06b5cb777b3a6735a84dfc3b7399"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07083a3bab88a8674752aa1ce2a7b541ad96b8e97371d9ea1b2d0bf59c516abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "941d9050fed454da64ea15f464dc8cf82b7a885269df723a7dc89b2bac6a2e31"
    sha256 cellar: :any_skip_relocation, ventura:        "a6cf36c2e80a340827debfe894b4477dcd16dfaf4c5e88524dd02ae4b5f4a31b"
    sha256 cellar: :any_skip_relocation, monterey:       "a83146b6e8b70980cfb6edef2f99a56a0fb31d9f829f1684395821408a3e32d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5165b8201128e76a6bb0172c895d736734815901589da575688aadd1a171f38b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"chainloop", ldflags: ldflags), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
