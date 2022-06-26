require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.8.1.tar.gz"
  sha256 "38be77b41a5c7d0ef4079cde4c2ece7c0278f3389646f3375ee5783d17c953b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109afd56f6ba532c7f6bb66a25d20a23a54ee84c9619ac2682ab2bce0b8e7466"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47785b0588eb2d3be60e954e3e97972e55fdb3da4ba8a76f70dbf9d586937f5b"
    sha256 cellar: :any_skip_relocation, monterey:       "ec23a1e9c5929a7e32c6cdd5ace4a92af0b13a819ec6d95313bf04c85d649f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "07c71ffec305b00e75ebd802267ac3201c960ff85e2690f928ce6198d0ca0146"
    sha256 cellar: :any_skip_relocation, catalina:       "209da245a714b9f157162eba337501f1da539e1e7990fb2de10892e5d12a2462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df014beb572ac9497c58ef306db56d073adba9d248a67ded5466c33ab5bba057"
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
