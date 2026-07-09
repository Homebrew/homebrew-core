class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "3efc1a874c7f4d8db67cace07d46c10e91e8e77571f3e1eb547f17d951c47f80"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15b93f3db967c905ebcc159db41e4f11e1a0e68cc9b4c5d9a04872114d97b11b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b93f3db967c905ebcc159db41e4f11e1a0e68cc9b4c5d9a04872114d97b11b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15b93f3db967c905ebcc159db41e4f11e1a0e68cc9b4c5d9a04872114d97b11b"
    sha256 cellar: :any_skip_relocation, sonoma:        "29531e58b8dc5b6700d013f9b2fcad64bf5a61558a122530c8ceb9f24264f7fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b8b10e5d4ea1f9f5cf4ce5a464c46cc9fc3be8259219c46b52b00af2a6c436"
    sha256 cellar: :any,                 x86_64_linux:  "498166390c4dbe308ad25e8edcab30b30affdd01b229c6f58c977d98e0df4ec4"
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
