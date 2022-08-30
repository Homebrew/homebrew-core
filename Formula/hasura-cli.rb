require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.11.0.tar.gz"
  sha256 "48863bb0fe86938c84736e2a9d710bea3ab75bc1f4f95723851cc7e23b0bfcfa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5990799d57f36b21902a8815d435dcb72bc56c96fcbb2625667bb23aeb07896b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "356c59e0af20af8ce9e14d085f50a7e32d17d606485e2eaaaf04a1374761cbe9"
    sha256 cellar: :any_skip_relocation, monterey:       "41601a4329028c6fb8e070aed49a0ba23f953ec9ee034749a3d3229e200c4a46"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5fcc9dd4d82c02dcdbd6e81483d416ea90161b469183ae98caab41fc99ca5ae"
    sha256 cellar: :any_skip_relocation, catalina:       "e11110f326fb46d3786e41d93cee97d90b42f1aee75bbffd2ffc8221ed440770"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c8260c2b16c97f5b18f5fd79dc6dee7d251ba669cf3e9531e9c9cca75cfbd7"
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
