require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "611bf8cc67520efe0bb4feda3a3555492830ae5568cff8b154c8fb721d7359e5"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81fdef14561538a045d8b79393e576e1d480890d053ba2ec78e1d35e9cde9b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e2e0150aacabeacef25427de082c0ea283d48bef447feb0416c2adeae37ada9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d94306eb8c16169172f971b7cd5fd7ef3b1b1ec6e2db9d7df963ac2492353d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4add959b02f8658590157a481c92b4ed66072d9c2e5ac0b6fb043ff174c71fa"
    sha256 cellar: :any_skip_relocation, ventura:        "152813c09280a56d72affb6fafa14b6b1570cd556cc2c51a9c4d199e2fd95ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ecf1f5f8a35430a846a4100f81ee8192ded4db1e894838135369e662d77b8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15e9b699d108c343075cbf406de5dad4db6b497668db509c7d359e6b64f6e1b"
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
