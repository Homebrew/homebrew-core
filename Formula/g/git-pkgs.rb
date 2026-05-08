class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "102f529fc19babecc5026b2b55f062153541a60f2d08e3c8b06a7f0ebf76a0bf"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddcf5ed07dd57384ad450c9a0ec0493f4d44bf69afc4098d1c121fdcfdbb6959"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddcf5ed07dd57384ad450c9a0ec0493f4d44bf69afc4098d1c121fdcfdbb6959"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddcf5ed07dd57384ad450c9a0ec0493f4d44bf69afc4098d1c121fdcfdbb6959"
    sha256 cellar: :any_skip_relocation, sonoma:        "270128dd3f7cab2752526a5b32e5985e6ab0a4744354006349f479d39523904a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73f2f2f6e37ff1a6c3e2159a4d191c30f9342b47e0df4a365fa11bfdcda7db5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d16a170439ff0e871ecc75c74d77f7b52efa50e31b640b087947ec4a30071112"
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
