require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.13.0.tar.gz"
  sha256 "e6e8ac2d9340fbe31de3cdd6dd21c0202ea928ed69f8b8870aeaa9227c982ef3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bce7edbf383f7122edafc92b0772bd962f6aab947080b135483cd7304f3af053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25d09dac82ca31194c095505491a4c7de3fbeef18a8540bfef149f30076b664"
    sha256 cellar: :any_skip_relocation, monterey:       "35f0605fa48ecca70b8f7c2a421f6f7f6a0f77c1c7f545e1b7eb84a3df4b42e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "39c6be10797721de942088ea18dd958d71d6169a79d07bd6ca3c5eb2c94d8d45"
    sha256 cellar: :any_skip_relocation, catalina:       "83a7a8db845d9180938c5de47904ccb347a9088a561c2af755c77452ae4cfff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf251f8bbb4ec593d945a5faada89e4f989fba8a8e75ffa7dca9be43954ef95"
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
