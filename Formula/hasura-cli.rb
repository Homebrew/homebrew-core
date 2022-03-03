require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.3.0.tar.gz"
  sha256 "12cc95078a53e6f9aab510ee9f5bfad3b0d08a949ff51d5c15a01add7e58bdba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5b35ebae0e745a1cba73c64f36311ff7481576bede8530bf9c7ce34ed90a471"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7393e8c8066339d9f96b9760f70f0dfb6114518248341d33a30cc2dd1736cedb"
    sha256 cellar: :any_skip_relocation, monterey:       "999015baa8f9c9a6de9299843da07fc6746488312050a1c42d69db72ef80e428"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ed94c868c9723fa841112e876ab37d7b66513c296051c0062f128132f237102"
    sha256 cellar: :any_skip_relocation, catalina:       "b2db961d45c126077f8331a3d5ebfd26556cdbfeb36ed52f892fe15972fe97ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c6d9e49862d3f73866ad31adf8e0176a13e6952c4dd61a3c0ab30edad7ee0d"
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
