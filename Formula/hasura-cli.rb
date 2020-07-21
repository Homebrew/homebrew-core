class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.0.tar.gz"
  sha256 "620ec18b644ef71a769086be868174752c261a639a8215472690fbf07a839ce0"

  bottle do
    cellar :any_skip_relocation
    sha256 "77d006e1f89a36169f6f4e8858271d0ad10125902c988f0ae6e82854b2610514" => :catalina
    sha256 "6907c2b64b830d81ef389f7535436571394205645de47492dd5bba7679b4a93d" => :mojave
    sha256 "a5e93c26c925bec1c45be398ad5431cd2b9a4f842af308ae0e94728a5b48ecc0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/plugins.IndexBranchRef=master
    ]

    cd "cli" do
      system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"hasura", "./cmd/hasura/"

      system bin/"hasura", "completion", "bash", "--file", "completion_bash"
      bash_completion.install "completion_bash" => "hasura"

      system bin/"hasura", "completion", "zsh", "--file", "completion_zsh"
      zsh_completion.install "completion_zsh" => "_hasura"
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
