require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.14.0.tar.gz"
  sha256 "364a4ba24bb9adff0b96d2d93e3dda86e11704dc9c578bfd224d92b89e80a1c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf3d70bd3155b9bb1f05de8d8813e0fcf2c7d0ab94816b518d89aeda6efd100f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6386fe25fee7c249a7bcbb465ec5e137152389771131b93a9d3f8bf9ff86418f"
    sha256 cellar: :any_skip_relocation, monterey:       "3b46547ff49207a70224c3397cf8612982a59808d93d198b0f4203b64e886b32"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4faca27c91ceb7bf1c64d2299eacd4a00d8676bc3b705601961641845920420"
    sha256 cellar: :any_skip_relocation, catalina:       "99e44dc55bd70f59b24d8fb2d63c9c173be4f860dda3e835a83b6a8abb27bb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b01d01df71ac117d9103538d4a426a9684a381372ebe2b4d61279010d91d31e"
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
