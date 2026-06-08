class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v23.0.2.tar.gz"
  sha256 "10bb1a7f5340ecd52b751d77efcadf49a748e12a553a6c94992286b379271049"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f730c0d9a873abb114d9d862a0963728387c17804c111257e53c8cc3a4dd18ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f730c0d9a873abb114d9d862a0963728387c17804c111257e53c8cc3a4dd18ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f730c0d9a873abb114d9d862a0963728387c17804c111257e53c8cc3a4dd18ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca0c173068d593bc51bfd4fc53562d97ba79fd864c41e88b25c9fa7b599f9621"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4d78e5abc5b4a4abeddfa22bd4436aef8960952703a8daa346ac6e32bec162"
    sha256 cellar: :any,                 x86_64_linux:  "3c11a497fc0f46b2700f8c95100c0829ea344df842ca2cc4bfffb07ab179c382"
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
