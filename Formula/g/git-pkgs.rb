class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://github.com/git-pkgs/git-pkgs"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "0fddf934169e7cdcc03b9bbee3358f3dbef2582d72bb9f4eddc56611ee9c1df6"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d29ddd8510863231c8122f863c8c7a515c464702822aec333ecc1c4f71876cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d29ddd8510863231c8122f863c8c7a515c464702822aec333ecc1c4f71876cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d29ddd8510863231c8122f863c8c7a515c464702822aec333ecc1c4f71876cbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "114f67bf82aaf3b523d549787d4339197d9c4e4c50c11427cde4e2d8ae4eb74d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1203ef1402287eb3544a7f6eaebca247fb481bbd12ae0d83b32021e4fe02ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38661cc5e398fc8613763aa87db97da5e5a1b8c79a01c5028b450dfaa06676d"
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
