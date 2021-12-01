require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.10.tar.gz"
  sha256 "ca134148d62985a065705740a7ca884a2f1bfe18c1f11d21b66dc17119630ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b860c096eb5e1dff44d852bb19b2a56e81508ebfc953702f102964ff49f3ad82"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e9eb9e3772e77b731842bca7e698160ba9184453bd8f8a989147dda31f4a1ac"
    sha256 cellar: :any_skip_relocation, catalina:      "d0d6e9f09b30df5dccfce820c6108dcc9d59323d68ec9ea815977017af6178c7"
    sha256 cellar: :any_skip_relocation, mojave:        "d6991bd9968d53743e816be3b2ad5de5a68018904160a5a2d93caf9fee45057b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e4c9e55c26b47d4f19e23bcb95370adb40e13caa68d59856630df7e43e001f2"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build # Switch back to node with https://github.com/vercel/pkg/issues/1364

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
