require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.4.0.tar.gz"
  sha256 "dc51c15653c8d36675f9e37d4a3a5e8961dd307ea62f6b76bfa565a5ea7f74e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9d378ae66ef1e7e9dba8cb14cc7e38631860928db6cfd4886908ff81355382a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b927ef89b2d6935907998513f56d393082ebc7c4972ad60e14c92d993d3ee263"
    sha256 cellar: :any_skip_relocation, monterey:       "08f118f94a95776cfde965e908b6d155c89ed96ae07562efdb3fb6121621257c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4424131441a78fa7645c7804e3525329700eb808517b6a81751b829755416cf6"
    sha256 cellar: :any_skip_relocation, catalina:       "bc1f502b006a9199adf58bacceace48723ba5ed92b3aeb5ccf2cdff0f91917ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e591e156c510a81ecf1ffad39e2288bca8d2c335dda646ac129c797dd8b16a4"
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

      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "bash")
      (bash_completion/"hasura").write output
      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "zsh")
      (zsh_completion/"_hasura").write output
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
