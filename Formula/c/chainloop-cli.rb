class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "4bcf5c1697b2f00a3c1702fcabe71f2446bdbd3f093529478ea338c93a8d21ef"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad25f118a1c7bbbe08440e81a25dfec585c57ed944a9265891588debc5736a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7e37cf5dc0a7ee7c147f0a2a99bd0cd10898dff627fe8f32f378fa5c20aa7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b411d3a9ff103acb025979fff2b6a8f2ce4a228a5f7b236598f96685b9cc63f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b75cdceb1741e99d16d4e1d9649387ee8f290fce153423c3e9185d27cc3dba7a"
    sha256 cellar: :any_skip_relocation, ventura:        "f624e041d869079d1199d725caec03a3be66714abd61b49681f406a39ce4df7b"
    sha256 cellar: :any_skip_relocation, monterey:       "3039a6cfadbe5ef8e5b31a7553c905c3277ab95f0843d07ba7d7a014cffe41f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "782bd357a21ddf1284f49490cc702db27c3103b1ee75d44556300fab26f4bdce"
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
