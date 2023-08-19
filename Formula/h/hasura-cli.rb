require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.32.0.tar.gz"
  sha256 "8c04f9712a134a8a01c1817bb781d10e74ee1730204f3b74fdb1b34f784cb5bc"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72193a4608965a5c19b13fca4fbcd3b96e29e509d0b1036c0f0d10e5ddcab21c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860d096c420454bacf8173a5c55a7cf7699324a80fda8b1dc0372a46ee940e58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39d1e2bd76cf590fbb0f9439a77c7bc2ab642e5895b410fe6e7fe03ac467c3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6ea955a14b394ab8bbf1500886707ad001a3d3d140bf6533ecdc58ade2119f"
    sha256 cellar: :any_skip_relocation, monterey:       "e25c72b245e81dfae1299ee6695ebe1125d7a0f5770a71a23d8905d626605de4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d05feea680ef9a70390a7b47c000b9a1247630d3e365db2420154c63682a675"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6a330ce3e84710df252d11cabc649de13f89b7b5f8542fc7c895091f3e3e545"
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
