class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.48.3.tar.gz"
  sha256 "ad7f7e85168e53671b3421d4947c5a6f840682ba0fbff834fb1ce2b4f3f9d6b1"
  license "Apache-2.0"
  head "https://github.com/hasura/graphql-engine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfac97bd3cc1844377187d031aff9b1628fac76275dc4423db2a977f87e8c865"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f385b53709497e0cdcf9eb34e8322cfac34fc063bb406cc542a89b9d172c859c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f385b53709497e0cdcf9eb34e8322cfac34fc063bb406cc542a89b9d172c859c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f385b53709497e0cdcf9eb34e8322cfac34fc063bb406cc542a89b9d172c859c"
    sha256 cellar: :any_skip_relocation, sonoma:        "310114abbf68ed17ec45b968303c43862c53cab6350cfd638475f76ffe277d11"
    sha256 cellar: :any_skip_relocation, ventura:       "310114abbf68ed17ec45b968303c43862c53cab6350cfd638475f76ffe277d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8cb7042b1c3583acb648add58487577319a4f4a1aff3309dfe1aad50a3af6b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c0b250d4b6e09f5d664f9b791792cf2bbb8f22881683b1566190bfcdcd3db6"
  end

  deprecate! date: "2024-10-29", because: "uses `node@18`, which is deprecated"
  disable! date: "2025-10-29", because: "uses `node@18`, which is deprecated"

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
