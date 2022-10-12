require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.13.0.tar.gz"
  sha256 "e6e8ac2d9340fbe31de3cdd6dd21c0202ea928ed69f8b8870aeaa9227c982ef3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c119e4215ceeee3753b524cf869a48470ca7ca8923a7d3f378ff9839284aac52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db11f2963dc2d4ee29dd5211f55870b375e8c88d9e81afe8a551f8b3c467d985"
    sha256 cellar: :any_skip_relocation, monterey:       "7d1167ed78afa5fd0af2a87df3c9038d45b82717091e42eee40b00216243c4e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c61b84e18d52ae765bb328dc39ab6ba4a4a01b53d323f71390ba32b3dac0f116"
    sha256 cellar: :any_skip_relocation, catalina:       "d9a7d8beaaf4e2e44c37f60fe841601db1cd7d7c7a338f5c1b2868827391ee9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb9893ad004f9763b41004261f96e7de08099bf168dbe480d553634fa5d13ef2"
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
