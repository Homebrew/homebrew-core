require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.7.tar.gz"
  sha256 "3f24e5ee3d74581de0abd35856b21959c0df38f0e80f4f1069ffb0931aa25bd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed8c967c8d9575bf17b8c7ce75fc64c2a24c1cab2fb32f347a7a28f7074694e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "33951b7c3b5be12a5111fe1a7303aa50e95584954285930ee6ed43b27b1fc8e0"
    sha256 cellar: :any_skip_relocation, catalina:      "8236234f8858d61463b820ad5c2d3418140c4e042c59a26209611e917de3be4b"
    sha256 cellar: :any_skip_relocation, mojave:        "0c28dcfaafe86b881a7470617bf573c69c63005a6d98b9bd2fef93ab0397ad66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7873d378c8640804520d81424d4f5ae84cac199b444c3a753980320dd1c8af50"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ].join(" ")

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "prebuild"
      system "./node_modules/.bin/pkg", "./build/command.js", "--output", "./bin/cli-ext-hasura", "-t", "host"
    end

    cd "cli" do
      arch = Hardware::CPU.arm? ? "arm64" : "amd64"
      os = "darwin"
      on_linux do
        os = "linux"
      end

      cp "../cli-ext/bin/cli-ext-hasura", "./internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"hasura", "./cmd/hasura/"

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
