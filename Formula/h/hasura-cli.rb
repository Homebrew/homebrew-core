require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "27dd3480815dc8c4a2f69eb210f6d805916b89a0fd29e2ea1585ce0317100e0f"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4995294c98d78db8d86127f2859f6d6d4c777d1fbe360dd35177370874cca66e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6920d946c11a81e893254f0d1411e7295e39dd8b323b699c214aa346e8740ff0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc58eb6e3a67b9a75d55136ed00ef6a961d23e7af62a97df9cd0b7148424d7da"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3abb038e20e0eb5f89b5c1630adfc6ca39b6d0165d0bcc5e2c42ca1acf20807"
    sha256 cellar: :any_skip_relocation, ventura:        "eea07a94809556abd49d91e20e2c1b49806fe040c4d43d89971afe1692e82a71"
    sha256 cellar: :any_skip_relocation, monterey:       "c2af24a2923edd4977dca925b52684ae1427bd0c4f4ded7724c22b6a946c34aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7812a0d10f5055f18653c81c2d92d4ce759eb83b8e124dbb31fa2bc3e8553088"
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
