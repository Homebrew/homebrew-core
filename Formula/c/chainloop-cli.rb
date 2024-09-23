class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.96.12.tar.gz"
  sha256 "1c1336e7701848acb56e82f02d5a17810d098083b69c967b7b82e8fa92f938a7"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "830ac3423ed9be4784773594439ab58bfd179c7b998c2abc452485685b8f47d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fbc10be5720669bd9bf9237fde1411b25172929fe7cf2858d9e7cba347cc708"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf0e129777fe5aa54fc8e09368ef67611bb6dbb0e11225f75f9332fdf6d824a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93363a1b6932f83b1e9a79a21cf7c99cdea5dee9e5c1ca77ee4dcd93c2645114"
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
