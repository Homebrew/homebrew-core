class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.45.1.tar.gz"
  sha256 "7f8a7c74bc6cf00b2cf5d4c738622976400c9577cd4a9d8c1aa9daa4707c674c"
  license "Apache-2.0"
  head "https://github.com/hasura/graphql-engine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49604b94ee609871da668a4b566d11ae72e625dfb2b615af548ecf94c0366a9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49604b94ee609871da668a4b566d11ae72e625dfb2b615af548ecf94c0366a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49604b94ee609871da668a4b566d11ae72e625dfb2b615af548ecf94c0366a9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a40a74089296d7f9e95ced1bf7c1156d7879ef6cf1c64be7725468e9642a10ef"
    sha256 cellar: :any_skip_relocation, ventura:       "a40a74089296d7f9e95ced1bf7c1156d7879ef6cf1c64be7725468e9642a10ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "747873ab215b0e7908f373f5cbbfc076619d798fe188f9a47875065bd7768370"
  end

  deprecate! date: "2024-10-29", because: "uses `node@18`, which is deprecated"

  depends_on "go" => :build
  depends_on "node@18" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # Based on `make build-cli-ext`, but only build a single host-specific binary
    cd "cli-ext" do
      # TODO: Remove `npm add pkg` when https://github.com/hasura/graphql-engine/issues/9440 is resolved.
      system "npm", "add", "pkg@5.8.1"
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "prebuild"
      dest = "./cli/internal/cliext/static-bin/#{os}/#{arch}/cli-ext"
      system "npx", "pkg", "./build/command.js", "--output", dest, "-t", "host"
    end

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ]
    cd "cli" do
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags:), "./cmd/hasura/"
    end

    generate_completions_from_executable(bin/"hasura", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
