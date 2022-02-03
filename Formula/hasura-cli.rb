require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.2.0.tar.gz"
  sha256 "15115a6cb860714126c99cc85b32fb5286d363aaf91050d7720cb0db75e5acfd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5d98beb39c61255cdf345ae9f958e8d8dbbf7310df1bc8a4faf34b5a6880846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c131c39d5550282e19a1d92cccd9c433e151367df693a8820a2ffcd912f54997"
    sha256 cellar: :any_skip_relocation, monterey:       "cfee21d4f090e9a6c584231a93873dba0538664c661883893a1902b067c2d2b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "515cd44c9894187946b56d618a89212c37ecb91305daf17437d2b3fe1b383e47"
    sha256 cellar: :any_skip_relocation, catalina:       "80a50cc8e5ce52c5747b5a920037f72b461b548f90043422f014dc2943983b17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "addfddae8901b1772600c4e7306ecf768ca9322ea5b5934928bb638583a77caf"
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
