class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v24.0.0.tar.gz"
  sha256 "850f47720cecdbb4ef49d0ead1a17545059020d9749c24b00ad27e2d1c9ecda0"
  license "MIT"
  head "https://github.com/git-town/git-town.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "805db95feeb4a493e7ce7d9427fec8ead0b2d72311e7f7d66884a69fae23df0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "805db95feeb4a493e7ce7d9427fec8ead0b2d72311e7f7d66884a69fae23df0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "805db95feeb4a493e7ce7d9427fec8ead0b2d72311e7f7d66884a69fae23df0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "51ee86531d32b11f65dd4a86dd10cf1cb4c61a5d2980bee6e9ac8c6505c46c27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "801c9c035d55ba6926780ba169343b737097db57b980d2812112c022929b9434"
    sha256 cellar: :any,                 x86_64_linux:  "554866f02be7eeccd2e567ae82295b9626464b11b484b097024c7522fd43613d"
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
