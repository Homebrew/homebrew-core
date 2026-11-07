class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "baed53b93bd3bfe4bf97cfcde5ecce4bec841825eea8e4030b51ef543c2a09ef"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdec30b4b912564c350378fbad6f3515fd3bb5997804bb9ceca6371694ede7ca"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdec30b4b912564c350378fbad6f3515fd3bb5997804bb9ceca6371694ede7ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdec30b4b912564c350378fbad6f3515fd3bb5997804bb9ceca6371694ede7ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f505d357c0525f7d2631122a57dfff6e3574fa3b412db8871bd29c4109fe2958"
    sha256 cellar: :any,                 x86_64_linux:      "a16c67cfb0c138287164a716f84c8e839be06423af74e9eeff18f39dc7599420"
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
