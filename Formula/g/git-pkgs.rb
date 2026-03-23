class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "bfcf5d82d8350e89f097afbc8e609540dac3065cb71e24baddbb5d7c5f058332"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2dbc5dcb41e8823f823a9932966134847ea0c3b0170eae3adb40f9c951cbee04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dbc5dcb41e8823f823a9932966134847ea0c3b0170eae3adb40f9c951cbee04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dbc5dcb41e8823f823a9932966134847ea0c3b0170eae3adb40f9c951cbee04"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b59d41057b8ee74e6022c597af52f8e2e2f9c76f4ca6b3528f428454033d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995c45e6e7b71f64060c2a10dd586d2bf2e90d94c9dd837b5e7699049cdba6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7ac0372ab24fcd889c834751d50b53714a016a862fad838d00810d828d7e868"
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
