require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.15.0.tar.gz"
  sha256 "1a55a998fdeeea50fee010f8d75c4fddd8e71461487187ddaa1a9f51f7f9ac67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e8e71e0e53dc03a3ced785957461033082aedaf2bd1d5e464c2281f22e4f76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d70e02fff37c7845026da83ac05d3e4af146f22377928343035b8ff6bc5b103a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d7b4b44d8b28e7c787868168fb147fd77d36226e1e95867615b0c1040d565bd"
    sha256 cellar: :any_skip_relocation, monterey:       "630bc66f2e328bee74b9562712bf8b9057284a6e5ea9475d570ffb0f804de8d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "17f61cd7da5f91b6afee2bcf730650ce181d8824af833aef70689866fd5d806f"
    sha256 cellar: :any_skip_relocation, catalina:       "b93c9cf3e9f37dddd2e3be2db6a768f1bac61e232c12bfc48f961fdeed1e2935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5f0ff9a4da0812358ba4f256f92b93069e53ec3fb722cacc01bdee39580a329"
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
