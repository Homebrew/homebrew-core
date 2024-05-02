require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "5d0710a77367ca184a900e9653de004bf9e5b73a3af5e59c34e667f29f63b965"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ea0707497c54c458be70f070e05f514da36597fa413017d7768585508354229"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56bca292fb6343a5e51bf829bbdef7c9b8ac3d88f3a5dac236eec0f53365b36c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92723d8db1829ce0b781431db6dc8dc389acf38db3ed966b0429add87fc3239a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8533e00484df09c56f106bc6f1e9b6f96dfc9ef9fc02fb66bb87733bc8580192"
    sha256 cellar: :any_skip_relocation, ventura:        "c06f31e843db60a5ccbcb50970b3adf4e8978f5d60e51c7dfa7ae1acd8d2d92d"
    sha256 cellar: :any_skip_relocation, monterey:       "9020e3d6a2c453201974acab911c6a6e55ccb52aecf52db38de29be20d4b7d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee5a5eeec37dd744046bde558e0c357b6cd5befb0c9065308b3cd5a5dd3e11e1"
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
