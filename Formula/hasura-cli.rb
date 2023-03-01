require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.20.0.tar.gz"
  sha256 "5f6354326f62ffb1521af3d18128668489be84bf3ea273f1351d4b912bdb76d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfaf163f333bb324b562fbed82dc88e7002ffe77aca8078f96732a590cea9c87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f28dfaf42a05d6dde6c631ddef6b290cdc21e3b5efd6c1771d93363a473a5c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b19be68e14f0f9dc13f3a5abbbb4135936baff2a8f0df0cb90c5cdd481760a5"
    sha256 cellar: :any_skip_relocation, ventura:        "17a2ff98830acd9be15adf133e0d160844ce5a5816966a68acf07436ffa1d195"
    sha256 cellar: :any_skip_relocation, monterey:       "1475e132c78cb42c278364f9d2f08ee19f9410b984ab86aad3134bd61e9aaffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d97b7b670287d8df43cdb8017bf3d96cad133df0fd08867fc546d302649ce2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cce9a5e4736d68bcf043a636d15651b11990df139b6e3f005d104799f8d9d30"
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
