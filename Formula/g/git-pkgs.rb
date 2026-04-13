class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "22f61720129e5863c4d15912c1f998ad04363c1be17cc56b93cb526d6ec3e62c"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ea57e0ab3291153f8a4eae42fc59b079242a078e3a6c6d37ab4e6ba374332b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ea57e0ab3291153f8a4eae42fc59b079242a078e3a6c6d37ab4e6ba374332b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ea57e0ab3291153f8a4eae42fc59b079242a078e3a6c6d37ab4e6ba374332b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e082868cae6aed162661ffb6088d98b05fa8c704d27522fd302c5b1550e3f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5a5a43d25b1ae4e54b73fff49e689aa3e0d72f37bd59d62b9a306e4efddb2d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "442124e06441c856e274e281bf465654263f0d30bacb4f45f472fa1e12d01fe1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-pkgs/git-pkgs/cmd.version=#{version}
      -X github.com/git-pkgs/git-pkgs/cmd.commit=HEAD
      -X github.com/git-pkgs/git-pkgs/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    system "go", "run", "scripts/generate-man/main.go"
    man1.install Dir["man/*.1"]

    generate_completions_from_executable(bin/"git-pkgs", "completion")
  end

  test do
    system "git", "init"
    File.write("package.json", '{"dependencies":{"lodash":"^4.17.21"}}')
    system bin/"git-pkgs", "diff-file", "package.json", "package.json"
    assert_match version.to_s, shell_output("#{bin/"git-pkgs"} --version")
  end
end
