class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "baed53b93bd3bfe4bf97cfcde5ecce4bec841825eea8e4030b51ef543c2a09ef"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c8a3d0c480cc8553f9516f55994db008876b602bff4494c1d61a8eb41fbe7752"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8a3d0c480cc8553f9516f55994db008876b602bff4494c1d61a8eb41fbe7752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c8a3d0c480cc8553f9516f55994db008876b602bff4494c1d61a8eb41fbe7752"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "449f8868d964f527769ebc218fe4f91dc763e2a498f0c1e13554bfb75c1129b0"
    sha256 cellar: :any,                 x86_64_linux:      "28cd7bbbe25f295cdc3f2855133b79580b780f39a6e25af67b7e5bd0ce1934c5"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
