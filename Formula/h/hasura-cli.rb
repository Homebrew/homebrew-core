require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.33.3.tar.gz"
  sha256 "4bb379f7609e1352b7962eb37a5c414a890a3ca240d3656dc41f297bb1e0f703"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c56a9ec9ee0965755f70283ee4f4769dea2b20b5092f8da5b6cea245f51b2472"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9649d4a658c5eae94cd16b40e6c06283cc958a2d34b4e695f27893688cd7a7fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a670b341721ca412c711380eb47a154ad8168c134b285a1e88991a92a333dfa"
    sha256 cellar: :any_skip_relocation, ventura:        "233d056b13210302aba214528a2a10b957ac8f204b526f785e1ff466619c3656"
    sha256 cellar: :any_skip_relocation, monterey:       "80c4efb20a7e27486320cf85838e2bfb3c0049109afbd804021fb742c050de2f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa3fe6271656acfd66bafcb77cab77ae460828c0aa5682a28d37f967582e71b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f95b76d3cd51411f9b56908ede5d09f0af1103c284921dfd897253718d559035"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags: ldflags), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
