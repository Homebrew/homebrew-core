class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.7.1.tar.gz"
  sha256 "1d7f136d5b932593281614f7a5ae2fbb8cf219233efe43022a9f93241c926478"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fce8b70d6c9d1d0c3cc0f5126fa75c4c017178dfedeee0580b5359c4addc6df4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fce8b70d6c9d1d0c3cc0f5126fa75c4c017178dfedeee0580b5359c4addc6df4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fce8b70d6c9d1d0c3cc0f5126fa75c4c017178dfedeee0580b5359c4addc6df4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9ccc510e87e6b1f75d47abedce1140bb7c8813aa4bdaef45cfbf8f744912ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85213a05d214ce5b3d4095239fc5dfce68e2574accfdf305482e0f0c84307382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d9b2922195885cfbf0415c236ab0b708c82c861b6b49becc49e11979aa1110"
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
