require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "0a5a72e880ce16a21b55a50e417f11814a0349f27302bf14c6ef4592eecf0984"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e23952a710b6924c5c53de3957abc9659f6d1b7261e59668a5a019a0ac4c3565"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd0f2bc432a15b9b5939ac7069a643b30fa6d0b2928d8afb2bac8af6e3d9a3aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f70764a0b489580fe37808212f889c6b37545cf17e178dd9e40bb3673969a15"
    sha256 cellar: :any_skip_relocation, sonoma:         "33c611a9f0046f429eb574af032d2041371cc45679324693a398fcc7b29b6048"
    sha256 cellar: :any_skip_relocation, ventura:        "ca13e6c9e8c076fe15728c632a93e1fd3e00bbe10a5190900594667f1b4b1576"
    sha256 cellar: :any_skip_relocation, monterey:       "11a59f68c116f9b1529236a8c5dd9954082f78ad58cf83978ae9d8ea0a067f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade1fc932351832ac3937abb57b148c0ef1f5da3e0b176ebf54260c9a7a97ad9"
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
