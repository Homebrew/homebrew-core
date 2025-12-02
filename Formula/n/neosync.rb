class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.41.tar.gz"
  sha256 "f11966321826d40d28b087b1daa81519e600759b9813b0e686ec49397a466a21"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dff0d67b524213408aba298d75f80fea1eafaf7756313dba20b8079d41b0f2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d955843c57eaa847b43b5aefcce7d239677049fcd650059f7b056df93b4ee67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d955843c57eaa847b43b5aefcce7d239677049fcd650059f7b056df93b4ee67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d955843c57eaa847b43b5aefcce7d239677049fcd650059f7b056df93b4ee67"
    sha256 cellar: :any_skip_relocation, sonoma:        "14bcd6d91cb2fd66bc410cc059692c1a25db636a2e778fbdff31ef10f7b5b018"
    sha256 cellar: :any_skip_relocation, ventura:       "14bcd6d91cb2fd66bc410cc059692c1a25db636a2e778fbdff31ef10f7b5b018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66642ba75fc6ba5df446549755498c22a0bdbb17ae84a7579cb580858b39d35a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9fe641cfecd902842f7dc37e292bc6eef5d6d545dc60bf266a59fc970de2976"
  end

  deprecate! date: "2025-10-02", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
