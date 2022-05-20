require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.6.2.tar.gz"
  sha256 "842ee73adb37e7a30c5a4be74fe1ea4e64c09013c3a2c23bee59f1648d1da3d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efb26e147e3adb17200dff7703b4a3b9774da10028972a06086fbf772854577e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "286096541b28a98eaa4ce89e84a39a4a0887f48df1bf768d0de554938ea70354"
    sha256 cellar: :any_skip_relocation, monterey:       "5142051ba1600f79ada909c8b407d0b44e85bc98c5e445f27e9682fc3dd8bcf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa3ba12b6e35505bffb58e7669ce1492eb71e46104ad28c03dbc3de9d69d3070"
    sha256 cellar: :any_skip_relocation, catalina:       "46fadb754662152c2ba10f72d6cb9898f042c1dfb7d430ab9389f17bb4f348af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1949b3858d1daaee412a24d3f14f4ca9c5ddf3080056f95529f711350386a65"
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
