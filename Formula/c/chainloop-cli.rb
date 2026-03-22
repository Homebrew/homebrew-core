class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.84.0.tar.gz"
  sha256 "45acbb404f2af530dabc37096d23f8ca617222ffe7a16195ac8b37cd3f4983d2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d64f05047e9a1d7295bcc23106162b3f30d3ad4f7e6000023573127a71c65e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd17d01c5bcf64579ad769c18431775694a799f7ed0c5f54b5bbfbecededfb52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b698c59646b048c6675b9352c7c9e5d61c66d8aaaf37ff0eb4d7054b48b20f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e08491ae68d7feee78040fbdfbbe5b3d24e9a1d091f8b0f572b11a9bc8f9d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5804b68d134446d32996b7d651316811d85f4303255b19b7065c56c48cf5fb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1adc5c22d8ff716ab0ae3cdec5090a83f7f8f2fb8bec6d5d4a6152dc79f9b244"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end
