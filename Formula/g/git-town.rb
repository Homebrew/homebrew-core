class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v17.3.0.tar.gz"
  sha256 "9bcca42a4bd0a84fbb55c35d027746d81869e5232058f819c7e683c80bf9f121"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffce04801150d89a0b1f6872b00d26908abb9ba241f61dd6651fa8b9ddf9005e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffce04801150d89a0b1f6872b00d26908abb9ba241f61dd6651fa8b9ddf9005e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffce04801150d89a0b1f6872b00d26908abb9ba241f61dd6651fa8b9ddf9005e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c5ed33b67f9797b1dc581b65d632af92cde9f00a05c6ccf5f8e93d301197a5"
    sha256 cellar: :any_skip_relocation, ventura:       "a7c5ed33b67f9797b1dc581b65d632af92cde9f00a05c6ccf5f8e93d301197a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa5752aa3a0894f28ae28f4ed0aadc2e8d83f44880138901b52b89f1b1d08e3"
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
