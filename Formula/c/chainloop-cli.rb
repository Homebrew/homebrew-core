class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "84c57660473d54c35c769e4c374e226d849f31688335d43adc7bc8c87625e396"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e6661faa34180a23cc64fc8d07061bb5057788f7bb92a6aa0bdb48782c8acc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47ddb7e44edebcc58149a958a1bd5db40df3e3f55261a0a7ee7d952a1a768ba2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8aed8eda2f8eeada467b6178dd0498ed4dcfeaf73f94e0958e6e97405dca48e"
    sha256 cellar: :any_skip_relocation, sonoma:         "66e292ee7edd3acd4f49765d690a0651bf39682b87c833308a60d31eb288a6d8"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f5e494deca229af7b4ef3131dea1a1b7602c972f3d479c6e682e3ae511faea"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d4544a073687156c9ff11bac8f6198d9d4e48ccf9113e61592a3b68b1b33cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e54607d7b9fd2efb52e3e3738d99b95cac95660c8dd4421448bd9d314571eb"
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
