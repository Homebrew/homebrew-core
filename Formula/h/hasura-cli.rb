class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "688e1e4af3e5c0d2c21de7ca705b1cacf5012db76f531052f68b7ab2967b8bf9"
  license "Apache-2.0"
  head "https://github.com/hasura/graphql-engine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c168fb8c60738f168484fce057b62ab295aebe7274a031f0008d8d5dc4e91c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c168fb8c60738f168484fce057b62ab295aebe7274a031f0008d8d5dc4e91c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c168fb8c60738f168484fce057b62ab295aebe7274a031f0008d8d5dc4e91c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "26749938f27c8883846ca3a6a80ab79f8820d32920ad209c6e5be5dcd7ca5300"
    sha256 cellar: :any_skip_relocation, ventura:       "26749938f27c8883846ca3a6a80ab79f8820d32920ad209c6e5be5dcd7ca5300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f966901ebca05ee6f398ce905d3a5fa0886effbc927eae0ca5d5655c86d5508"
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
