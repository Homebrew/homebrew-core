require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.27.0.tar.gz"
  sha256 "571fd3362fe1243911a0ab345277aa2b65a51ec74f07eed2be5a448c7b1eb70b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8de718156b44c364622fa0ce8e85d2b30aa4c0389a16e51684ac41ec9e121372"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac36e41932b852707a7d1f228a4c8ca15b0881c920a34f4282ace5cba3f8cc44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d34db4d62b0602b6fad801c215e73363b510668aa751ae79e0817a367415b645"
    sha256 cellar: :any_skip_relocation, ventura:        "0eed0fab78f9f77ebcdad1f3658e63d83d13a01e967a2d8612c8f3ed79c2380b"
    sha256 cellar: :any_skip_relocation, monterey:       "e491ad2436966db001f5fcb86783c5942bce2c2d48fa493162a9c2ee05c46025"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33a06837876e1e9e6992b47cbc10a3c460d043fce5049eb8b25b770a443d7f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543d7442eb8e11aa6b0fe8ef48bff989309fa83338b5e7710a5c85c20d6a7ff9"
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
