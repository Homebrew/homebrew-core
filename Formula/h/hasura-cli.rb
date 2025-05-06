class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.47.0.tar.gz"
  sha256 "77302d2040a4b751ab4cd380a3e1ae076c766f5831f50e9c1b129daf4f29182b"
  license "Apache-2.0"
  head "https://github.com/hasura/graphql-engine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cf82800a978f1dae7eedbfd498ad07fa51ce5f9897aa65be9d50a4911f81777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cf82800a978f1dae7eedbfd498ad07fa51ce5f9897aa65be9d50a4911f81777"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0cf82800a978f1dae7eedbfd498ad07fa51ce5f9897aa65be9d50a4911f81777"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8ff28b8ab7095ccb9f8b1f8524572daa46b3b4288b052f8af84c20d3b08d28d"
    sha256 cellar: :any_skip_relocation, ventura:       "f8ff28b8ab7095ccb9f8b1f8524572daa46b3b4288b052f8af84c20d3b08d28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f028f4c15eeedafe1f173248dc2eab692611ea7b5ff40831a2c6897ba8ab3b"
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
    assert_path_exists testpath/"testdir/config.yaml"
  end
end
