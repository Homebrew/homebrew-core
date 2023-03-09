require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.20.1.tar.gz"
  sha256 "b3b10ed1485cc18c5d46cb3386b442e464074d5383e9d5e9685d7e5d2c1b92fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd1049f0c0b75ff3a66d85773026a04f072d47a58d3458fed8fff8f659564d1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e0d25104637efe86169557428140d588acb8dcdf790660efc65f7d621dc272a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e46179995aeaa290e3ab8b9c329d5cb891b0af7f3dfaa56b0cc4dbf832c85fe"
    sha256 cellar: :any_skip_relocation, ventura:        "75e0ca28130588dfb0991df3f27fb15534f2b4d1ce291ce55c04c63452e08848"
    sha256 cellar: :any_skip_relocation, monterey:       "7d51c56586221480ff423d2ceeef523c7ac5fe1f12aa83badf41cd4485a61b9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "13a0beb1662b8c089cc6a4e622bd62569d653be720d60b3ce39f53798a2998ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba03b5bbcaf9fdabf2a31a46861abd9e4982fa7e3af12f75dbad7b2db270c673"
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
