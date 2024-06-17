class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.91.6.tar.gz"
  sha256 "749baf25c994b5e7ef749a5709de1da534faa9b7564460b02c68191cdf61ca44"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "776bd97aee624e5ff8598672032a7332ee4e8e7ce5e7b35138583aef475a3930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f6f1462c7128d568d365df049224579fbede46f07e04e3d8105641fcaee9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "695a64e542d94620c24558b80fc9b447663affd8bc1ff8df3e48b781b547d7a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "63b40f2dbb0786fa4d725906301ce6676a778af13f13fe59772c15e9e6f472f9"
    sha256 cellar: :any_skip_relocation, ventura:        "094e84485a0aafda797415c01bfe6f570a038ead06dad6c1cd9d576f52ecfe61"
    sha256 cellar: :any_skip_relocation, monterey:       "c63085718d6bfea6c701212bca6a1193d69e459551ce8903a101a51e244c9dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe39340d36c46c43ff77f88be393fa148d734e0cbcb95f5fdece9690a3c4f62a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
