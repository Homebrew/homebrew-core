class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "5b8947dc936ab61cc495930034d611b25ecb82b3c6fa292133146f2a7f6cb3b4"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60cbc28e8cf5e121956b70ec9369de8fd88476627c1b99b66b7ac17e9d466b2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60cbc28e8cf5e121956b70ec9369de8fd88476627c1b99b66b7ac17e9d466b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60cbc28e8cf5e121956b70ec9369de8fd88476627c1b99b66b7ac17e9d466b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f385a45d73c21aa2afeacea8de2937202fa5da68bae33381f260f09937204ce3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5878d41d5d55748f21dd2db68a53c9736084a39b718981fb62d8d76194b39e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a96f5a72f32e9359c0858aa38417f9d2740a1e353bb1b0857ad75d13c2573c"
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
