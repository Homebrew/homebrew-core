require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.15.1.tar.gz"
  sha256 "cd44dffcd8e63f4bdaa4714d13d8944b5364451979dee46effefd6fe95a82538"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90d56dbff02f2f1ee367f08705a9530d63a0296e27dfa9ca3828c690b2e4f210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5f80f0b0b80c5244d459267933e5af1c3ee2c1f78a0fc065fdd44794dbe9685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f9300bc9715d5c901b21f6b3ea8ed043de270bdd9cae513429d0320c9851bc5"
    sha256 cellar: :any_skip_relocation, ventura:        "f080cb94a23c209d1840bc5f434c8b48ced35cadced83cd8fbcf8115184349f0"
    sha256 cellar: :any_skip_relocation, monterey:       "ef591c195d5f3da3c1e92023c5e79a47340df848074b181c0049fbeea971d98b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4633b4eb9af24bb914627749d4cecad310f4658c88cfee9269bc4fc36a253067"
    sha256 cellar: :any_skip_relocation, catalina:       "2198c2df7b353cd250a14ec119fb7bf5fe84659c400cbe8ecd8b1ff3a434c0b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe43bb7b60366fc151ebc8c0fae818326923e0d860326819c54323d1460ccf5f"
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

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
