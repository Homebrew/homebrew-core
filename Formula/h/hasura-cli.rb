require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "3dd2c4d9ac22d5cc627bd5f0835a2e8e266995e8bc34bd83f80f9225e9d20016"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b684a2e334e2d909cb286b54b99ae47d37696d8cc4007e0219141f5ec2e6fdc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9ed17adb3210283d4bd2529b44ff61345e90bf6bc8d2085e7c11c0a39458d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e33cabfbb97ad8c9f2be2d15b5a449828126539b19476ea6987150241f1dc5d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d788ec34d024f8058d5bb2658d3e649d6031a3bba2b366a1bc16f73e40c49ca9"
    sha256 cellar: :any_skip_relocation, ventura:        "c8a6f67a4245cbd0352858f4f0fbe444e6b82d068466201cc3b0560662b2f3c0"
    sha256 cellar: :any_skip_relocation, monterey:       "01deea5c506941d4f4067e49675b2a2d141f7bbe821223ac70fe1545cc078149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c546305ce2de23649f559ec9e3e779dbb65888139a250a8bfc961e88c7c9215f"
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
