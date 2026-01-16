class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v22.4.0.tar.gz"
  sha256 "5c4e87257874b5fa3e756cd8a81a984b3a931261ed90b48f0d9b74b1b13c8b80"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00b264461ca0bcf6e1255ee825518477a08b95d85273ae3d143c8f248b374521"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00b264461ca0bcf6e1255ee825518477a08b95d85273ae3d143c8f248b374521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00b264461ca0bcf6e1255ee825518477a08b95d85273ae3d143c8f248b374521"
    sha256 cellar: :any_skip_relocation, sonoma:        "274817fae0a2d487ef953e76b0977d60093ae9ac666c51cebcf72ceab204f006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7b828d3c2af2a668927b184a85328ec90982e2d71b0ebc47aeddb235e65514"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a515f4726952b157565c7f4ecf5abd150c1c2745b81071ee0e2dc4149714a3e3"
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
