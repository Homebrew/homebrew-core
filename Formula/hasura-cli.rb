require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.21.0.tar.gz"
  sha256 "86aba72bc6101ac84e2aaee5bdf6508a4c706bebcb30d32c84d02da2dd28142d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baf2acf174e4587890638747fbeafc0960b4f7fdd12069990d3d676f23145738"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58530f4c9957dbb419c58cf7f7fe8e736cdbb6fb5fe429fc5b5881f7d047a00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bfe6b6ebef5d596f2876ba32216f3581a4bc1aed8072426b85b917581892340"
    sha256 cellar: :any_skip_relocation, ventura:        "09b1897fbff1afa03c5f8c0c0a23d2c5d9a3b17fbb52263caf6bca23a49da687"
    sha256 cellar: :any_skip_relocation, monterey:       "0db7c1a5f22503219876ce99bf7e062344be3c3ba2d50d934131fc5cd2131adb"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa81bbc9b052f20ff83db5d2ff6c6a61ba51c43895565ac5b6f953ccc9f51922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8af932ea419ad6841d597e121ef0d80f68aec2be502b1ce78e6d6dafcd3a4dbb"
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
