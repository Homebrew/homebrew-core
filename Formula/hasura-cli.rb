require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.2.0.tar.gz"
  sha256 "15115a6cb860714126c99cc85b32fb5286d363aaf91050d7720cb0db75e5acfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2a28c3ecb567b64bc7ed5a94c48f90f308f8511e545f07d0f730e5cff46a04e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c6a12b8d59e29e216b6a0cb25b0c3a6f27726e1eb378cddf4c0ffc4a3eb0661"
    sha256 cellar: :any_skip_relocation, monterey:       "446c11a002940143c811333026ffd62ef130f44a2c0ccfb5987b14ca40ebb91f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c71831fd7b9f17618e9cf869d9cd66fa6704a8d6874e82639e32083f0651b0c7"
    sha256 cellar: :any_skip_relocation, catalina:       "804de66f9dd9915b09c5bd5f7f7da1ca389dd46e92e4f405de3ae415b578d68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bd1d9fd15a2222fced3f0afd83ef21577c9584eb998ac0ef2e6f288ba49367a"
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
