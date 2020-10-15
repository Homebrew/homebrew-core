class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.2.tar.gz"
  sha256 "e6f1293c8aba9538e1cceceff4ad0d060303d2a9f07777f08b171485dd20cc2f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "85e902904e462772a3f45e236178195a61a71daf53ca2dd488e8aafbd5374be7" => :catalina
    sha256 "204859c85e1cbe73eeffb0a02641f23d607ead9aa4a90337c9c6e64a1b219c3e" => :mojave
    sha256 "0b2eac67491041cf2ff84dc7a1b5668ee47c8aab366edc8fda3f943347f396ee" => :high_sierra
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
