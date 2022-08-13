require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.10.0.tar.gz"
  sha256 "460eac51dedaed3a5993017fc204263406860074356447392fa56758ebab5219"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be06653a85756748e61bfcb10ffa1dec894c11772e7bf49ddcd405032b1042f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02c8e5bf90f7ad8df45225e0a23be91a16f28ff6fa518623d38ce109fd611d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "6a6273b9f9b3a6eca725ded4d25dda18b98ec974ee2b8a4d53b8657932db9a3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "505a203839d4f33200b6161f029874bfdd672bf6fb729dcf391f3af51474d983"
    sha256 cellar: :any_skip_relocation, catalina:       "5dbc5e728ee410b0d58c90e289e852894761cd43fa9bf9227a532277f9405230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ffad96331f0aa62dd14bc42e15ba2cfcf0f259e73e394e8c216ac94429e2158"
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
