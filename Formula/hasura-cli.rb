require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.8.0.tar.gz"
  sha256 "1e5df7d5c4ff69ea46daac626e97bc6217ec46662effdba8b23d87a90de998db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffc2a5f74f73067ebbf82b5dd292d79b10f3b257dbcf9e1af757bab54a6eb5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90652e3632c405357a741372b0e85e44fa0dea9895a506ea8b90055c8822bb47"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c23ec0810b0a3043d14d3af9c3d8df9a3cb731952f4c4537cf185e367d758b"
    sha256 cellar: :any_skip_relocation, big_sur:        "532c012d23a2991759f151773f4fc2e14852cd6b3354bccb8ceff503b731ab57"
    sha256 cellar: :any_skip_relocation, catalina:       "65c822f1f73cfeed5c9fcffe7602d2a3a7ec6541981d0a2cfc0d07a60e8529eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d6ffa79e9efe4b65ffdae46cbe2fedf5c20ae4caa941a2b002d919f42eee525"
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
