require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "7bc4f33625f589b9f7b5977d14720f21c1ca93697e0f199a3240c99c0250c7c1"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "631d6e6b73ce0f68eebdf3ed2a2f5c355469466f3e5d8741da6c42416bd6fa6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b48c62e203b00baf391773a9bd493c76d41d0710edc4a79410f0a0353b7b6e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f644bebfb7c167eb835e031d3232218e276a5ffa0dcf2ced7658d94cadae1f5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b7e795ba579e722ca29239d76443d2b5877a8554b9c1cb09f964115ec4de29"
    sha256 cellar: :any_skip_relocation, ventura:        "0f8d8b93a01a3edc64bff034ad20edf3a17e2d5af0a4262cf9d5c1b274483e44"
    sha256 cellar: :any_skip_relocation, monterey:       "21ad2a1cdbfd83c59343f5390c380ec0451e6d4e954dfe0cd850bc05f5d1467d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9eb253077c0b1a4ad9576028f10ac7ea96b2c2fb08090fd1aa3491809e58025"
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
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags:), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
