require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.8.tar.gz"
  sha256 "b5255ca63b0d158dde7dba186fc6262cd69d0a724ebddf00d10ea67044bdd16f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65861a74c8a6e314234e8ad2d6b027bc1e839126d57d7320bb4c61b796f85429"
    sha256 cellar: :any_skip_relocation, big_sur:       "3a37cd0e5bc7f0461799441801ad8ccb1eb8635358a7ca93fd4e93672b9191fd"
    sha256 cellar: :any_skip_relocation, catalina:      "54920639a6a1692071d8bb7433c9cff64d27b2f150d987f3c01c9097674e27dc"
    sha256 cellar: :any_skip_relocation, mojave:        "b947e0b84d522bcb4aa36f61ec7427e9086a4de69334a60b3d116404b733e598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2a9c042e1f8660113b26681f3ed655b1fb9ff3af5243dfd0cb5fe01d0f0dc8"
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
      os = if OS.mac?
        "darwin"
      else
        "linux"
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
