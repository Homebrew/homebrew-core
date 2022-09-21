require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.12.0.tar.gz"
  sha256 "7dcf08b0efe433d95e0590266ea3ae9c6f892f712b21b0207421bd0f05bff216"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63bbb652dfa0314cb20cf3d8f84177cde90020d9e2f94845f02c822b8190ea3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f3824d7d1291583399bf789ec4a7d0dc6f20c11b8aaa1be90067ab7af315128"
    sha256 cellar: :any_skip_relocation, monterey:       "d82211309482dc2c60d759aa193800c45847cc27c83feb2b71daa58f0e944983"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e2cf43ab627458924abba936fede390a2f0103b99e7cb53c3dd362b5c604dc1"
    sha256 cellar: :any_skip_relocation, catalina:       "f1fb8798864d6e71cebadcf244afc7dc7b2e924b2f76124a69b0427e1b64f763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30fb0f9c3c3f35a3c91bb3b292b4cec263f246163fa4592819c789fa4e787d77"
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
