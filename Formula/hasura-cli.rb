require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.3.0.tar.gz"
  sha256 "12cc95078a53e6f9aab510ee9f5bfad3b0d08a949ff51d5c15a01add7e58bdba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "880459ad7868152e9615125b38c4ff0a23fedbf9d3d77f7846f3a6784ef61987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "641279a27bd17833ddfaf8c1c81a66c3c541c07a9b16e3a9578dcee7ffeca8cc"
    sha256 cellar: :any_skip_relocation, monterey:       "0f4c7e7be239e116583bc8b11d75d9243dc9b138c5d3ec8343f12840580d83dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fdbb834c14bd042c184b9d7274568efc152038376dd3a059c8e57d16dd366d8"
    sha256 cellar: :any_skip_relocation, catalina:       "0f1a7b9528b0e427cba1d879fc00f446bcdda5db32537a95216e9574401b3c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "464c87a647b696fea2d59b9b0ed3e1570b7f02600ebc16b84ef372803f506113"
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
