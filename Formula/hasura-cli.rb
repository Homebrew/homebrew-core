require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.4.0.tar.gz"
  sha256 "dc51c15653c8d36675f9e37d4a3a5e8961dd307ea62f6b76bfa565a5ea7f74e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0af4a8c874739c380ab811e154168117987c6f959f9c02286f425aa79b544d87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4dbff79dbbfb6ce9b6fba830b5f50dd2b612da56dc0369cf241c7c447e1231"
    sha256 cellar: :any_skip_relocation, monterey:       "f61cee4a6c5a179ee3ccf17ade6bf8aeb38909c2d7bcbca2416e6a6ab8e14f88"
    sha256 cellar: :any_skip_relocation, big_sur:        "07831fb53499ceca6ac4af37855f433d274c356285da42ca586c58a9dade4a43"
    sha256 cellar: :any_skip_relocation, catalina:       "4aedfcdce154b623b764d5ef5b2bf6663155c52b1ef3720a015a22f2aaf35c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15c3d49b60537d0bf01a89d3f9cdefa10ecfb633e7561e4c77c534434b4ce76c"
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
