class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.2.0.tar.gz"
  sha256 "93d9b599d14817eda971703aef3c7df409b051611ceda014ce175fbe42bf1d69"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a6f344c21e5c5331b4a384a29e02d4c658e96af8d81ed0cf9309f8511c11dea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a6f344c21e5c5331b4a384a29e02d4c658e96af8d81ed0cf9309f8511c11dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a6f344c21e5c5331b4a384a29e02d4c658e96af8d81ed0cf9309f8511c11dea"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc644c14a5fc084b09f6f45528715a246938a5770c929c4fe1519e3a1e261eed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "522853b31d148e4234c12d598ae52644ec078d328daf66a66f2878d5a71e80bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a46970dc6756e5e5b5fdcbe49e3125627abc107914278d51085dc3cbbd28fa5"
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
