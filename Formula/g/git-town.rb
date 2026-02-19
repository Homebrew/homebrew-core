class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.5.0.tar.gz"
  sha256 "96c79b1f15625d0604c8b7f0d41ab8d079ca5c227e890261ea9e3cc5897a9d21"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48b0f0ea1451ed6e8655775e94ec1f8634a9ac4f726b878ca8a64e96dbbcde7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b0f0ea1451ed6e8655775e94ec1f8634a9ac4f726b878ca8a64e96dbbcde7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b0f0ea1451ed6e8655775e94ec1f8634a9ac4f726b878ca8a64e96dbbcde7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "181e57f1b1541357ea6edfa7a67a3363ac6c03ab0e1275c253d5a98c7c335372"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78ecc362045b12a036dc24e1c57b0487a8e45d222756642d68ea83c8184e831d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72347bc2ffb617e25f2e3475977e94da195b8474db0c2edc18d89c0c6a6a54b0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v#{version.major}/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
