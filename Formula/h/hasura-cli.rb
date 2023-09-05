require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.33.1.tar.gz"
  sha256 "45e9dfa40c0073ef97ac7faceced4c91cad0f1e9c16a45caeee731f385e4210b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a9419369ccb234dffe6eabc39001c193558cc1a998618d19c9bc4f28d8d514"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2108300c38ba42b9cc5361295ad7571ec7da642543c04e98ccd5caa8b009a74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582a82ba1a49c45be21dc4f301522c80908718ec1b14ba7f09e34d5a907b0df0"
    sha256 cellar: :any_skip_relocation, ventura:        "d51e2d6728a2333673daf264d08ed4c1afbd45fc9a0ccd18a7009f6f0d49c747"
    sha256 cellar: :any_skip_relocation, monterey:       "81b65e45873aa39e8349116e29c5a13c4e4f75520dc24b3e4b0c909d970e655a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0957df57c48c7c3c7423b89c6932e80c45ce12bd2be226d8be3e821efc782c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3f81bd02177e84dcc6a99a322e929e1a1651b98ad6a2c1eaf81e4d66dac3fc2"
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
