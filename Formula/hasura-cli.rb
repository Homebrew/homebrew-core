class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.1.tar.gz"
  sha256 "0241b1ebc444f98292bf943cb19dd0bbaa0694a16c5d6d7f0a8a14e9f45cdd8b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b1b4aa16d5f355ee318189b13076d71c84ce18c3dba4d790de9a5555c1fa4c0" => :catalina
    sha256 "552166554a2ba329ffed87238619971d8d68c1ae5279ff1d94c85e776d044e3f" => :mojave
    sha256 "dbadb855600d3722c7ba1b88c612f7f2c435a20d6139b0e8849dca8b920dcc1c" => :high_sierra
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
