require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "8c5e4a3dc59d5383e23e21504f9d4ff49f281bf8ec8f92bd47b6b2489f675218"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3797cc47ca161abe9943123f8305070f3c5c9a043c1cd5d6090f340ecf945b7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f86672c1abc275fc2dbd908994b14db897fc3803636e1bdfa58be898452d83f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "507ebdeb5279becbcb3155f06a8cb034974718b21fa8ace531eee3e97d137b7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "08adc36d019024574b883bc57b8be3c0b0bfad36e454b46f28dd1f7e06f1f895"
    sha256 cellar: :any_skip_relocation, ventura:        "c645b373990a35f59eb96b78a430ded0ac898609527eb34f7f488f3a4eb7191f"
    sha256 cellar: :any_skip_relocation, monterey:       "8c13cea421ef34ecf4e55af937c7b592fd96a4ada89eeb374a3a03828a800217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bffe11547dd0f7f06bfd6417be6521f3d62aea8dca020657d834a9b58e37cd87"
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
