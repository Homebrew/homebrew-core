class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.0.tar.gz"
  sha256 "620ec18b644ef71a769086be868174752c261a639a8215472690fbf07a839ce0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fb7d523140d0bd29a718d0229527c477fe577c99e27e0fc3afc1ac0e86a136a" => :catalina
    sha256 "37848e6ffb30e4e3d105c86645e4aff00a999fe69004bc20a509b460c1e557c5" => :mojave
    sha256 "d3b87534950c33e7339ad0b6a4cd4eff5aee368bb36e7777c1f6b5d76200c733" => :high_sierra
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
