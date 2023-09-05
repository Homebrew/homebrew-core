require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.33.2.tar.gz"
  sha256 "be327a4879291a3b8e5d08e5af58a19f0abb61c1ea003cdc4efb81ef4a588c90"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8bbaebb97b0f925c638dc5b5a37f662c70e6d3040d63252726f3f0a83c34954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493b7b27148030cd4f49ccb0753c41f38c2c227a3906006ea2bd042fbbe6565c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9545bbb79409f2fc7c38a7d08a5ddfda146ead64438847051ef9995c130f6d9"
    sha256 cellar: :any_skip_relocation, ventura:        "361fac5c1fdd856249210bf3e8675229b29e568791afc12a9a7d98983b9d0adc"
    sha256 cellar: :any_skip_relocation, monterey:       "4de8dc324a1890184c265a37778ace33dcff8cb939f75d87bbf6c46e74f2e4fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bfe71999b0b63375e9868d81652aea8d5ae63f6a73974adbe890c74141b598a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deddd869c241e7b062c3edd2891ec614b7757d097e82922eb20ae57faa69c0eb"
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
