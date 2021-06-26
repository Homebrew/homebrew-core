require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.1.tar.gz"
  sha256 "b541041b0fb42b663987ac23c00bca1b7a1cde43378119f4c7339ff7b6cf0ccb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90f9efbf8a5ac77e1b95f3f9c27b47434466945001c53967bb3b76574187f10c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6762f5df7daeac39d1cfc97c3359c411c47e01c78eaf1c1f255949157b8107fe"
    sha256 cellar: :any_skip_relocation, catalina:      "1ec67a4ca2d2aba2bfff2292d7020bfeef5539a0ee8eda025e7d7f7837706adf"
    sha256 cellar: :any_skip_relocation, mojave:        "88431c7dd38c9d117228b1c0d87355760bb8ea0fcfc4bbfc7f9125e3381905ce"
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

    cd "cli" do
      with_env(CI: "false") do
        system "make", "build-cli-ext"
        system "make", "copy-cli-ext"
      end
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
