class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v21.5.0.tar.gz"
  sha256 "790e40a667019ee4497debb749b07f64d72a656c9569f640b24331ae8a685d01"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ee0aa85af670c7e7fb9040789a5fb909af47ce4f6c020e18a84a415c051e909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee0aa85af670c7e7fb9040789a5fb909af47ce4f6c020e18a84a415c051e909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee0aa85af670c7e7fb9040789a5fb909af47ce4f6c020e18a84a415c051e909"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ee0aa85af670c7e7fb9040789a5fb909af47ce4f6c020e18a84a415c051e909"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb3f028f6259515d946f8d75691c9f63a0029a51fa8fbca26c08b05470c091a4"
    sha256 cellar: :any_skip_relocation, ventura:       "fb3f028f6259515d946f8d75691c9f63a0029a51fa8fbca26c08b05470c091a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "654fcd23fdef99904e563e497c90321bcb6ca21674b48bbc76aaccfeb4dd71d2"
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
