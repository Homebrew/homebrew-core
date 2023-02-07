require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.18.0.tar.gz"
  sha256 "2e9a79d8dfe497b8234f7d91683f1fdd4217081fc4cd3f0f9e177d53d061d99a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d5577abe3aef5d0cf3e33991be11c890c43baf5ee5495b491640b3057582a9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c860a5c61d6565765af1731b5cb671c0022e6cb6ff684005eada700ec759903"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12ad6fbaf9d11a8a9020d31488b7c52561c9074cee54adf72d4171b139f3fff1"
    sha256 cellar: :any_skip_relocation, ventura:        "80e4945b5cf9f511ccceccb4388f838d85ef3643006e1e5eb2b21a8f3265022a"
    sha256 cellar: :any_skip_relocation, monterey:       "d159311128a8a4a5fd4aeaff4ea258a29e61cd3ae5c264d04e9f1240f672bf13"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae777c8428a20e4b54a07dddcfc2c14173a080473093e6a479e9dd680732237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ee44fd157397bd0bdbfc47f613e61b9b0db740b38820510b0340926719d3df"
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

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
