require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.23.0.tar.gz"
  sha256 "84527562e97476810c604753b18f9c689bbfd38fb4ead9acd499ed56e3951215"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b5c0a3a3af591aa846881339074896c973fcd1fab26331d41b11194ce349146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b31fefca434a42f8aa9f4d0c54827afcf4593dccec83cc91cc27f1b9631cfc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325ca6c50d962a620f9b641fb49bb099a8c4fcd73a37dcaf8f2579b0bec7c6f8"
    sha256 cellar: :any_skip_relocation, ventura:        "449112d96ca6e4c8686024fbc85baf2dc56d34936a549585101c9bfcc83f5e9a"
    sha256 cellar: :any_skip_relocation, monterey:       "a1fcba54bbcef81b18faa690510b19dc60ea586b48966eca7f25570cabb8aa2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e7423873841ec36d12cbd37725ebcceb3fe889e1bf78d581689a1e3265082a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58c9b73d75e25078163011968e7b8b17036a405d17aed037ecb28c19ac1195ec"
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
