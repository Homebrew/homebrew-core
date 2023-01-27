require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.17.1.tar.gz"
  sha256 "c09a6e877a0ea8fdaf5a2ee511a3b83c86eb1634254a319a62abd41ec999b40e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de0fd91efb2dbf2f42d6ccee7513c0b63a126a8c761dec0dcc489a12bc3e22fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28a67627df0bcd72472e7c54e06daa5680135de920f75a4b02dce4875f4d748"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43da0ab7fe568ea71020b313ebf434076067eafc07a1c4fafbb6c2b32ccd1839"
    sha256 cellar: :any_skip_relocation, ventura:        "505746360d58199d4e88f5bd0ded546451aacb1ff280254bc65ea3cc6f0f357e"
    sha256 cellar: :any_skip_relocation, monterey:       "34ea2054dcfd5e4ba779453513751e27fd86a8298fa95cc4fa74b0450fb333bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5859e16e65d938c74b686a798a7bc6a7c1575f8e85da2065c0a82271133e6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc3eb5205b465fcaf88d862f1afbed7c75d4714d753dfad4e73bda729b95bd6"
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
