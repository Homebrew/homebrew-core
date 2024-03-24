require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.38.0.tar.gz"
  sha256 "a5c5acd02ddc30f2c1b335e9894bab47b2812946d9c9d1a04090e685c087cab5"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f69d97185f66113be010c6f0f3fb2212daf18e3e25b07aba2b11a688e7a07659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4c6918771b06b658134a86c89eb069e57f02bf2c2767ce5c6b7f236a0d3bc52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c50225eee9a1172d7cb6321a8ac81047cd6ea7449baac37dba78ddee7eb27ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6f392d56ea98b59fa4744b0526f2af860b4716c0596ae0aa816e0f9c0ffb965"
    sha256 cellar: :any_skip_relocation, ventura:        "8d45aa53fb5ac149c382c3c65ede6e59ed747ee7d489b01214baa0ed993a4660"
    sha256 cellar: :any_skip_relocation, monterey:       "5a12ed3ea3316f3d4d3427fece93dfd2cc6d92407cb745234c66bca2d84dfacd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d56ab1af481b9b753613ec9e2fa4906fe96d574bace08f4a022504057c50a913"
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
      system "go", "build", *std_go_args(output: bin/"hasura", ldflags:), "./cmd/hasura/"

      generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
