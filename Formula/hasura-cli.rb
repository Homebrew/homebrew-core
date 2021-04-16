class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.3-patch.1.tar.gz"
  version "1.3.3-patch.1"
  sha256 "a53d9dbbe127a2fe6a2693d9a00ed351d607c227507f563eb75fd81fcb17b7b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "90f9efbf8a5ac77e1b95f3f9c27b47434466945001c53967bb3b76574187f10c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6762f5df7daeac39d1cfc97c3359c411c47e01c78eaf1c1f255949157b8107fe"
    sha256 cellar: :any_skip_relocation, catalina:      "1ec67a4ca2d2aba2bfff2292d7020bfeef5539a0ee8eda025e7d7f7837706adf"
    sha256 cellar: :any_skip_relocation, mojave:        "88431c7dd38c9d117228b1c0d87355760bb8ea0fcfc4bbfc7f9125e3381905ce"
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
