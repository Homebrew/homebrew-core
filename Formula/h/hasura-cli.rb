require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.37.1.tar.gz"
  sha256 "85257fecc97a531987bd3a4a7ead8a8fefaf46ceec8b0147401b8e96f87a5d77"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7b26a7b256ce9e1f347103db342e543d82caa0daf182ae650576fd6e41d7644"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fd7bd2dd7d358172fefcacfd5bd93475d076a2f012d2f53dd128fcb0e836e04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19ec773fda89d2d62e9a3496d95e88382974c9cbd0c6a1a32892236cbe6fc38c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0df5f505196a2a7c10e75bc217dfe6dc1aac02e551bad9ce812e1c27124a95c"
    sha256 cellar: :any_skip_relocation, ventura:        "4372809cd5eb4f0cd80759d7f60b7e5594d5d9800f773ea6665756839a2ddafc"
    sha256 cellar: :any_skip_relocation, monterey:       "e8380bef701fe10db4f55aa1d265f58c54ab755bcbee32e54e34c5a376f1a34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166ebbe44ab0e1753e2e4db48debb3ca36a1e75c85423f7485db84f5fc8d9420"
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
