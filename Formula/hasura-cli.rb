require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.19.0.tar.gz"
  sha256 "f53d304ee0f6cab1a9f1e8a7d100b258bf72a111d80b21d94cfc65b47e75f177"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b81d5bce3f9241417397f7fa0128b0f86c0810bdcc71b11c4773678a81a070c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496b510ac93ca82cf1bd0f249aa304d4ccb54a2ffd27a5b7cc11e3be07ef0d59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "585d51a7df03f25aa6e6992213ce8cc2db163d85241b9395848db6489360f099"
    sha256 cellar: :any_skip_relocation, ventura:        "fd25763ae4e715c111d12eca589daed99e0ff0cb2b9140973679b585bd7cab49"
    sha256 cellar: :any_skip_relocation, monterey:       "7a06a95a896a1b7ad919a4309d0e077392b721c51755d9bae791a63af3c604c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee090d8b8a411a8a3ba94721fe0a139818b95cf678f83232de820219b8ec28e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4ce7fc936afe399580c6e80ab4f5af33bb55f0fc67bdbbcdd4767b5d49f921a"
  end

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm update pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "update", "pkg"
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
