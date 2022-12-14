require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.16.1.tar.gz"
  sha256 "8459860005fd72d01bfd0a52e64c0e4ac355578a2e7076df7b2a13f3c0463513"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c226ddd96c89ae021eaffb68b73b6cb65714c5dc93de7aee38a6cc994b7b74ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a2de361ba1445d40fce8b33b30f2cf68544fba6d43ad04532c2b6112617bae5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f38c69ffaa3a1723de8102665eda10a944d06b8a4c22b5da1c398af8c4ac39"
    sha256 cellar: :any_skip_relocation, ventura:        "e6ccf5aea910ca6b273bacbda7c9d0b280699dc1acadacedf77477452fb8f58f"
    sha256 cellar: :any_skip_relocation, monterey:       "94d8e34e5b86871027c3c67abb3c65f8dddd537ed60f7e6de615d67c42a42d3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54d10726932557e6cb1e67ac102140b1b7aa9a7495ba56d3d8283c45462d71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "624bb0514b25820981034a6a72216c90a6c86d5914fae8106cf27cdd78833fb1"
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
