require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.11.2.tar.gz"
  sha256 "d04540d5fc4cfb2df028fff891200c904db6bd80db71ac209eec68214b853b4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb61fbd15e404e30f8a18b23d5b8b1586832bea19f93bd97e09a50ef3c303f01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1e85caa54a73f88af3f0c775453f542b894bb52ef5db2af5e1ed532f87d9055"
    sha256 cellar: :any_skip_relocation, monterey:       "6ce940faa9a9864177108b4e0276480343686697ec79f544c977d572dcce7bb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "209468a336cf878e4132c93516eae5de5785b754738f28e5b605d4c67e09034b"
    sha256 cellar: :any_skip_relocation, catalina:       "50ed60a688f133f0a504539fb12d14ea5b7e36b067095d1d9815ce9411eff8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3b8518d75ccf29b65177cf4acb2e95a5ad18b6259f1b9833f01446c38ef314"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build # Switch back to node with https://github.com/vercel/pkg/issues/1364

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
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
