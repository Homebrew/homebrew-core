require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.15.0.tar.gz"
  sha256 "1a55a998fdeeea50fee010f8d75c4fddd8e71461487187ddaa1a9f51f7f9ac67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b8df69fb4c687f62852febe9d58619686ef724b28c3e6176227712ccc5f2aef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603753a12b7a6c7f88997ffc14d1754898265655189174c34ddd9834a7b672f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b57552f1a247ee3701cc021fb6c81e54db073a452beb135ec72829166329355"
    sha256 cellar: :any_skip_relocation, monterey:       "91d2001aef76a9a6655e8b3f1393fd933fb90c2c62086acf9b7e73bd10217878"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d2339230d466ee5cb493977a05bfc0326c259d21cfc82b6447b3e54b3f6f8ae"
    sha256 cellar: :any_skip_relocation, catalina:       "0d017eccda9772098f3a03c4c3dd8c6c5e5c300a77e980e4e1fa649fb0be7420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6f243a69f20d7cb8528b9500c2c9216db7eb8d8830399fe2d5a7f0ff247d2e"
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
