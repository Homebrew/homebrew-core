class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.3.tar.gz"
  sha256 "20d6e4d2da8e9ad4008683e3427e496ce9a96044b549385595bc681acbd8607a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "63fb6beac11ceed626a3db6e977e3923c5b82c9ad92261e16347c1525de21ba3" => :big_sur
    sha256 "c75583b93fe038d352496b367fa54395b98533cf6207fc1167cd7fc8adc19850" => :catalina
    sha256 "97daab3e17d9e02f3f57c5e47e4c5471c5e82898723965231e64ba3c4fba4f6b" => :mojave
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
