class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.11.11.tar.gz"
  sha256 "7178f70892a309bf829565fe1655212e14049d7b62fe7a5e12ae2ef665b16d55"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eba6acfeed1cccaad7f293e552de14f8d384b383bb3cbf130052865f9078a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48fc66e43663f0d83f8063477b8756b22c55911cde53bdb8c1b1e45828205a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72ac7041817d652d50c94ee7bdecbcea0bba205d0eb77ab61bbfe0356faced96"
    sha256 cellar: :any_skip_relocation, sonoma:        "748e0bedf1313d9bceb66224f49f07a05abaecfa97853c2760052d1456d45783"
    sha256 cellar: :any_skip_relocation, ventura:       "65f2a04472120752d8fa6f1abda224d507885d2bd6ea684678922c8f80c7c092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb864a8815d8e389f05d2545c87eb2a24ceb0cd4e683ae9ec38e1a8286d0563e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293fe4f2addefeb344fbcb7d3d8aeb9834ea8671c4d45145fda0dde1fe4b3c0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
