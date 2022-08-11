require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.10.0.tar.gz"
  sha256 "460eac51dedaed3a5993017fc204263406860074356447392fa56758ebab5219"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b2da64c48ee82d4f54db3c27b0831e5cdcd86694c2e3c41414ad0fe27ae3678"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c4c44b3a14f62f27045e4db783cae056bc4227e0b0ac3eb1e752bdde9692af"
    sha256 cellar: :any_skip_relocation, monterey:       "ff6bc4f95a4db0a7aabdf22a5a5e18cc179cd337865d1cd15c7c7429f6764731"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcfe5f739fc320fe774203b670a076b274b765f81754d9abf16430cb77c3862d"
    sha256 cellar: :any_skip_relocation, catalina:       "b14d73ad7e3dccbfe34dac818c6fc83c78a29be9c82276b0ef647fa23be54ce3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9a57ebe1130fcb7198c38abdc62b36664c8e19328fe85ccb62dd9111ab09926"
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
