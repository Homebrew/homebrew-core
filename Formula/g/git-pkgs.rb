class GitPkgs < Formula
  desc "Track package dependencies across git history"
  homepage "https://git-pkgs.dev"
  url "https://github.com/git-pkgs/git-pkgs/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "1bc7f875fc3f15481a565233d73dd63e3b1a5dad7d382545cba0552e393939cc"
  license "MIT"
  head "https://github.com/git-pkgs/git-pkgs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8d1b1efa1d43f169986316d56be49d9d9d3ac922978a3df9a9e25407613d19f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8d1b1efa1d43f169986316d56be49d9d9d3ac922978a3df9a9e25407613d19f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8d1b1efa1d43f169986316d56be49d9d9d3ac922978a3df9a9e25407613d19f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a15ec40609121d2311faec0e47ac9d663b3c8b2a9c6c60915430282adb8ea53e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c591500955d3affb260aa93f4cb7be35e85d599354d290b3b25e67903f30139"
    sha256 cellar: :any,                 x86_64_linux:  "2841da21b9bfa081a5e9993ca0e058ac9efc092ea6d777446d1baa4e3d86d9a0"
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
