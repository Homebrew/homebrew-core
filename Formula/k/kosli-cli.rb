class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "7e0a167a825bd33173afe5b01be11b1f3e03d652b97c2ec68c0320964a42c17d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "835861af429d6f63ac2602ab3e014bd993bdfcbf29685656caa4778276ca82db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b960ece73f93c095b58123d9dff3b907c6940b3c05330ecd53100a42b7e6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d416bf3ebde7a5e2f08da35091d40a74e6bec99478ce327dc123cd2526bb46f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d75706b8db366003b1d04935f926fafcc61be31d44c226636305d5f4648c7e78"
    sha256 cellar: :any_skip_relocation, ventura:        "bb243653da4f9f599c1d49df2947e374c621b1de70245542c94ed84e7898ad71"
    sha256 cellar: :any_skip_relocation, monterey:       "52cc57eae09b99ef7fac2762eb3e079575da52d3b3fa78f84f6f48e85a3af7a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a245996e24870ad0c444f6173d45a65850e0e5575fa2c0ae71ecab5a02a0d6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
