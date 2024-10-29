class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "3cd6b1937da62d8508c42b1e28f446a0c695fc10c8de43c7520e2e9c716eabb0"
  license "Apache-2.0"
  head "https://github.com/hasura/graphql-engine.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b832aecbc4490a78ec5bf29a85c5a3b39e051d9021f763c02116f3371c7855b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b832aecbc4490a78ec5bf29a85c5a3b39e051d9021f763c02116f3371c7855b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b832aecbc4490a78ec5bf29a85c5a3b39e051d9021f763c02116f3371c7855b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9d37d37777448e0dff756e080834e4ad5d99d02064e22aa22dc6e4da16cd0b0"
    sha256 cellar: :any_skip_relocation, ventura:       "c9d37d37777448e0dff756e080834e4ad5d99d02064e22aa22dc6e4da16cd0b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b28dab837f5e89e4f3d2e21351274f68d2447049e7138a76c55e230f552968e3"
  end

  depends_on "go" => :build
  depends_on "node@20" => :build

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

    generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
