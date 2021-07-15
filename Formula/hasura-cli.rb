require "language/node"

class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v2.0.2.tar.gz"
  sha256 "7aec0148882ec69a2cd978f9dc806e49c0bf7a16c86ed210c2422ad8f213849c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c283d8141f7a1d6de2357d8f726af74ff90f961b4fea7d5ef0e3f721c0fe446"
    sha256 cellar: :any_skip_relocation, big_sur:       "108701916af25e5784ccd3fc38aaf12437b67f5c41c88fdd04b4ac9988602c1b"
    sha256 cellar: :any_skip_relocation, catalina:      "72522aad16ec52ae3130492fc69a17c9385176aae6c71adf15558b0981c2fe7d"
    sha256 cellar: :any_skip_relocation, mojave:        "fb281d38c15b2214d4ca888ab09631fc2d7f5d73347af09b74f13f9f02ce311a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba7aae19afafa4dbda04c4b020d69ae81963f2d23879694a3818d0a4827c0f01"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/v2/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/v2/plugins.IndexBranchRef=master
    ].join(" ")

    cd "cli" do
      with_env(CI: "false") do
        system "make", "build-cli-ext"
        system "make", "copy-cli-ext"
      end
      system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"hasura", "./cmd/hasura/"

      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "bash")
      (bash_completion/"hasura").write output
      output = Utils.safe_popen_read("#{bin}/hasura", "completion", "zsh")
      (zsh_completion/"_hasura").write output
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
