class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "edfce5a67b1995df3fd53b765cc93bdac10622a61935d6158533cec314ce7d9a"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef9e448aa15d2e4ec6f68c49cf643aa96b4e93c8041ea2117423eea39c34168c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef9e448aa15d2e4ec6f68c49cf643aa96b4e93c8041ea2117423eea39c34168c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef9e448aa15d2e4ec6f68c49cf643aa96b4e93c8041ea2117423eea39c34168c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db926864c2bf7f44a082f83f6561f8ea425dab4af90bee944b1863f9542869e6"
    sha256 cellar: :any,                 x86_64_linux:  "857da9c52f64ba47c1d5191b0a51e2e4735363b9e0e31994d7566c0f38e35cd6"
  end

  depends_on "go" => :build

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
