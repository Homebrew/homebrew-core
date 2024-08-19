class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "b004a5771839cd8e4108f7bf9632ccd48d475a85f95f2f48de1d01644b0f2a1d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "915184e2bb92080db4672f819539f873de6261c1def567e21a8c85f4f4406302"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcf3b411923c4f779059474ede89fa43e1b62f3a3836b1d00e81983fdfe442ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "651f9d83beee7ac94783c4f9ff55f7eae58986c0f951fa097e7697468075543d"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a196ce6d4738917291d4cd3b95c6620485af5a424dd6d23c237c61c1fa2523c"
    sha256 cellar: :any_skip_relocation, ventura:        "37562a18fed3f3edad12b95cab5cdf4c94754d06cc81886459d3a4c2d8969b61"
    sha256 cellar: :any_skip_relocation, monterey:       "34709b52e42a9c90931a0b672746eb4f48ab99e27e15c2e5c4cc21d4abdaf64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b132e8080a9f3fa057562a0723124f5df4556afba7f8ba8dfa800f8a487f3e5"
  end

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

    generate_completions_from_executable(bin/"hasura", "completion", base_name: "hasura", shells: [:bash, :zsh])
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
