require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.1.1.tar.gz"
  sha256 "b7de5b7d008c03f9d84dc2261d4a931f51eee7b62b14ee838ec46844ed301746"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c5dda2e996d094b4b9556835826608f0842380abc2fcb0720ef4959b755dd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e57404d6789d61d2594c6b97cf67ab04b62c403d89e89622765b8837937aca9b"
    sha256 cellar: :any_skip_relocation, monterey:       "98c3a7b896268b3dbfb6de8731ab163b8781621fdc8724493c9465cff3d8944b"
    sha256 cellar: :any_skip_relocation, big_sur:        "700cd0ce6c36f06536a64031a0a157f004b63d94de2feb254aa07402a4b6d522"
    sha256 cellar: :any_skip_relocation, catalina:       "751b3af46c3d487f43c7998b16f874eae9dedc2709c11d166b2b05e30d0c9328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ba73d55dead1da6c2ee0e90009ea4d39a52d017280444a29135c615bf908002"
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
