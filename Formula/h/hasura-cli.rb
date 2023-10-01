require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.33.4.tar.gz"
  sha256 "6b135a2cd5d4a90fc9f89bfa18b0f691e55ef8c9845bb734397dad34165ba6b8"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8730a3d4003b277b36a22a2f140edfd9f7c02f619131c06c8dda898e115373b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e734e30354ac6b23eb840df15321cb7767c2cd42231174bf211dc265b8f6a77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78a0dae10a1a5c78fde5db7ee4ebcd3e1bc6c8fa3810eaf945c2ec3615b81820"
    sha256 cellar: :any_skip_relocation, ventura:        "8e0dd57f4c3aef860ffcab2185764ae12a0dfec09dead0bf4989827dbc9e0128"
    sha256 cellar: :any_skip_relocation, monterey:       "11318263852f5c0537b870335674e4fefed7ac4b55e4c43d4c4d8af2d6e65c59"
    sha256 cellar: :any_skip_relocation, big_sur:        "6044616b25b9b826eefb2a2bbd30b415daa075c4cbdee8dc21cfa73b48af5437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2219d6230c22a9754f316b86aa5c92c3b6b80dd5b08337bda2221735e0a6c5b2"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
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
