class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.9.0.tar.gz"
  sha256 "318295e5a662f785662751f1e2cd4b1f613ec3aced1c4e7f1755d27922dbfdbf"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e4b0a075ce99228e030d453d1c2107240190a99ed81d8b33fef4408fa4d6f578" => :catalina
    sha256 "d4add960bbc4b9e5e7e58f3bd5cd792b449572f78488d290b4397c91f8fdf125" => :mojave
    sha256 "4cea4e4f287a06c47d6e3a7476a324facafe3364ba2bd8afffe8da4521fb6a31" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "make", "bin/gh", "manpages", "LDFLAGS=#{ldflags.join(" ")}"
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1", 1)
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1", 1)
  end
end
