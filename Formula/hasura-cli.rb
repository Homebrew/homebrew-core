require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.9.tar.gz"
  sha256 "68dfb0d179cbaf2c9370948ec8c0d80acc69eae0acf821753deb134f0eb7a068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "88f1fb0852498d556bbbda8b28fca12fe68ad85273c225dd834b924e83f892bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "5872fb87d2a6fa1551169fa052ac1bda58d8efc79104460c5fefb72d8c7e17c3"
    sha256 cellar: :any_skip_relocation, catalina:      "37071359a0525fe672859fbc3bd4d14af92314d1fb3b2ba7c2f7551e1c2d8b3c"
    sha256 cellar: :any_skip_relocation, mojave:        "d51bacadaf710fef613e1f39276fe5bb3fba78ca25491cc738b35e26b83812a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2463554c0e2464a799e5351c59e9d904534be62862e9cfa6c8884256df2645"
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
      arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
      os = OS.kernel_name.downcase

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
