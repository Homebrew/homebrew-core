require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.28.0.tar.gz"
  sha256 "c22cd03e1df65384cc8ecc23973ff353946f0c8d75979973e388e111d7521578"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78d07bb89bd29e9079bf8dfcb9a6e1d1e4b1161a4c4d412370e4fc3142c4347b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59483049d2dd27cfd41e35d7fa4611de0104fe0c5bf8d0faa1763d64059b2068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "609ce71e3f84e810324975d9d9994975cb1767dba2b19134a025ed7fa46826c7"
    sha256 cellar: :any_skip_relocation, ventura:        "a661466a26ab208273bbfae302b8ee02a92422504f22fddb4d8e32950ad21f8b"
    sha256 cellar: :any_skip_relocation, monterey:       "dd9e2e9acf1eb9897e162ea602c19586d648d4fb0885164bd7aaff69b4c47aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "591572761fa3c0b1fe50dff2269762687d4920d60fa71a24513a8727bcea9803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c2ffef37bfed8cf8525e12455824bd0cbf0cbe96064c2ce99736a9ede1f4e9b"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
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
