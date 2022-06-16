require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.8.0.tar.gz"
  sha256 "1e5df7d5c4ff69ea46daac626e97bc6217ec46662effdba8b23d87a90de998db"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "42b7bb26e4b34039fbe047c5578316bc1936c3b935b2cad9f28eb57af51bb57a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30902898a5c78bfd5af0d76c3050efc444c0672ba99e8b05f981c0a00cc23c99"
    sha256 cellar: :any_skip_relocation, monterey:       "a529d5e7d9b47ad25faa674c82cc3276cdbd1b273462b511296300e19329cca3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a34dba02c11743aa8ed6e486a7e58448e8ba954c60f6885ad5b0ad9397aed17d"
    sha256 cellar: :any_skip_relocation, catalina:       "7d5569e9d0433596823d751a120552110777223debfcf056a0fc8d0e22df45e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9d113cdec9f5004299d98167e208b38dc7388a26022519c835d69292c3bfd8"
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

      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "bash")
      (bash_completion/"hasura").write output
      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "zsh")
      (zsh_completion/"_hasura").write output
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
