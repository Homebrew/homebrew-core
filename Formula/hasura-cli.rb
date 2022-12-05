require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.16.0.tar.gz"
  sha256 "91388e90cb1b797608e3eec24d785b806d12950651fa20038e02795d210060e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23900eb6db0fcc49af0ba0fb3ab7965aba4c33115380e6caee1563d4abbe2cd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31aba8fff037d26c10ccf326b3c569c7be3eafffd2b14e00911acd9366801ac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0f9902c1bcb9e0bf96765a7e624b21b3f249d993f6035a2da73b55ee060147c"
    sha256 cellar: :any_skip_relocation, ventura:        "46c882b9ba4a08b3824302144226259ce987c49bb253160c83e7a36b4eeb41bd"
    sha256 cellar: :any_skip_relocation, monterey:       "74c4e912a26dc5cfa5f7b284aa1fa25e01051022a6a4a5babd3c79592380d2cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfdae767e19d85a0497dbf0fb1c6800a6e42ab6bd64934d913020238aac5c11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57315392598e217a355ff301435d60281283b95a0307b7f66aa65372ce7a8b17"
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
